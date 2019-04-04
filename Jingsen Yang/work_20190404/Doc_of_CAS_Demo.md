# The Main Processing of CAS_Demo on ARM



### Abstract	

tanji-3上的主程序包含两部分，第一部分是调用DLA运行神经网络，第二部分是使用ARM调用usb camera以及HDMI Display驱动，同时完成神经网络算法的前后处理。

这里将会主要介绍ARM上的函数，也就是程序的**初始化**，**驱动的调用**，以及**前后处理的实现**。

```flow
st=>start: start
s1=>operation: 初始化
s2=>operation: 配置摄像头
s3=>operation: 配置显示器
s4=>operation: 分配内存空间
s5=>operation: 从摄像头读取一张图片
s6=>operation: 运算
s7=>operation: 将结果输出到显示器

st->s1
s1->s2
s2->s3
s3->s4
s4->s5
s5->s6
s6->s7
s7->s5
```



### Step 1 平台初始化

打开linux系统中的各种外设，包括IO Buffer（两块板子的话），usb camrea以及hdmi display。

1. 打开外挂在linux系统上，与Gensys2相连的memory文件，以备后面配置IOBuffer中输入输出以及与握			手信号有关的寄存器地址。

   ```c
   #define FD_MEMORY			"/dev/mem"
   fd_mem = open(FD_MEMORY, O_RDWR | O_SYNC)
   ```

2. 将SD卡挂载到一个新的文件夹中，以使工程可以对插在Zedboard上的SD卡进行读写操作，例如将网络的输出结果以文件方式存储到SD卡中。

   ```c
   p_shell = popen("[ -d /mnt/sd0 ] || mkdir -p /mnt/sd0","r");
   p_shell = popen("/bin/mount /dev/mmcblk0p1 /mnt/sd0", "r");
   ```

   ​

3. 打开linux设备中的HDMI显示设备，以备后面得到网络结果后，将图片的与框图输出到显示屏上去。

   ```c
   #define FD_VIDEO_OUT        "/dev/dri/card0"
   fd_card = open(FD_VIDEO_OUT, O_RDWR)
   ```

   ​

4. 打开linux设备中的摄像头设备，以使工程可以调用摄像头，从中读取摄像头捕捉的帧图像。

   ```c
   #define FD_VIDEO_IN         "/dev/video0"
   fd_video = open(FD_VIDEO_IN, O_RDWR)
   ```

   ​

5. 打开Zedboard中上下左右按键的GPIO接口，这些按键是网络开始运算的开始按钮。

   ```c
   gpio_open_push_button(GPIO_EMIO_BASE_ADDR,GPIO_EMIO_BTNC_OFFSET);
   gpio_open_push_button(GPIO_EMIO_BASE_ADDR,GPIO_EMIO_BTND_OFFSET);
   gpio_open_push_button(GPIO_EMIO_BASE_ADDR,GPIO_EMIO_BTNL_OFFSET);
   gpio_open_push_button(GPIO_EMIO_BASE_ADDR,GPIO_EMIO_BTNR_OFFSET);
   gpio_open_push_button(GPIO_EMIO_BASE_ADDR,GPIO_EMIO_BTNU_OFFSET);
   ```

   ​

6. 打开Zedboard上的LED灯。

   ```c
   #define FD_LED7     		"/sys/class/leds/ld7:red/brightness"
   #define FD_LED6     		"/sys/class/leds/ld6:red/brightness"
   #define FD_LED5     		"/sys/class/leds/ld5:red/brightness"
   fd_ld7 = open(FD_LED7, O_WRONLY)
   fd_ld6 = open(FD_LED6, O_WRONLY)
   fd_ld5 = open(FD_LED5, O_WRONLY)
   ```

   ​

   ​

### Step 2 配置以及初始化摄像头 

在打开camera设备（/dev/video0）后，通过V4L2驱动，来对摄像头进行配置以及初始化。

1. 检查设备信息。

   ```c
   ioctl(fd_video, VIDIOC_QUERYCAP, &video_in_cap)
     
   fprintf(fd_print, "\nCamera Info: version information\n");
   fprintf(fd_print, "---------------------------------------------\n");
   fprintf(fd_print, "%-16s %s\n","driver:",video_in_cap.driver);
   fprintf(fd_print, "%-16s %s\n","card:",video_in_cap.card);
   fprintf(fd_print, "%-16s %s\n","bus_info:",video_in_cap.bus_info);
   fprintf(fd_print, "%-16s %d\n","version:",video_in_cap.version);
   fprintf(fd_print, "%-16s 0x%X\n","capabilities:",video_in_cap.capabilities);
   ```

   ​

2. 配置视频采集的参数，包括帧的点阵格式，图像的长与宽，并在配置完后检查是否配置成功。

   ```c
   struct v4l2_format video_in_format;
   video_in_format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
   video_in_format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV; // (MJPEG, JPEG, YUYV, YVU420, RGB32 …)
   video_in_format.fmt.pix.width  = osd_width; // frame dimension
   video_in_format.fmt.pix.height = osd_height; // frame dimension
   video_in_format.fmt.pix.field = V4L2_FIELD_ANY;

   ioctl(fd_video, VIDIOC_S_FMT, &video_in_format)
   ioctl(fd_video, VIDIOC_G_FMT, &video_in_format)
   ```

   ​

3. 向驱动申请视频流数据的帧缓冲区，设置帧缓存的数据类型，以及缓冲区的数量。

   ```c
   struct v4l2_requestbuffers bufrequest;
   bufrequest.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;  // video capture type
   bufrequest.memory = V4L2_MEMORY_MMAP;           // set as memory map mode
   bufrequest.count = FB_NUM;

   ioctl(fd_video, VIDIOC_REQBUFS, &bufrequest)
   ```

   ​

4. 查询缓冲区的状态信息，根据此将缓冲区从物理地址映射到用户空间上，并将申请到的帧缓冲区，放入到视频采集输出队列。

   ```c
   struct v4l2_buffer BufferInfo;
   void * video_buffer[FB_NUM];

   for (i = 0; i < bufrequest.count; i++) {
     	BufferInfo.index = i;
       BufferInfo.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;  // set the type to be capture mode
       BufferInfo.memory = V4L2_MEMORY_MMAP;           // set with memory mapping mode
     
   	ioctl(fd_video, VIDIOC_QUERYBUF, &BufferInfo)
       fprintf(fd_print, "%-16s %d\n", "buffer index:", BufferInfo.index);
       fprintf(fd_print, "%-16s %d\n", "buffer length:", BufferInfo.length);
       fprintf(fd_print, "%-16s 0x%X\n","buffer location:", BufferInfo.memory);
       fprintf(fd_print, "%-16s %d\n\n","buffer offset:", BufferInfo.m.offset);
     
     	video_buffer[i] = mmap(NULL, BufferInfo.length, PROT_READ | PROT_WRITE, MAP_SHARED, fd_video, BufferInfo.m.offset);
     
     	ioctl(fd_video, VIDIOC_QBUF, &BufferInfo);		
   }
   ```

   ​

5. 开始视频流数据的采集，摄像头采集的数据会不断填入输出阵列中。

   ```c
   enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

   ioctl(fd_video, VIDIOC_STREAMON, &type);
   ```

   ​

6. *从视频采集输出队列中取出包含图像的帧缓冲区。

   ```c
   UINT8 * input_data;

   ioctl(fd_video, VIDIOC_DQBUF, &BufferInfo);
   input_data = (UINT8 *) video_buffer[BufferInfo.index];
   ```

   ​

7. *在读取完后重新将帧缓冲区排入输入队列。

   ```c
   ioctl(fd_video, VIDIOC_QBUF, &BufferInfo);
   ```

   注：6与7是分别将图像的帧缓冲从视频采集输出队列中提取，并在读完后将帧缓冲区重新排入输出队列。通过循环这两步，便可以不断地提取图像信息，这两步不会在这里使用，而是在step 4中调用。



### Step 3 配置显示器的相关控件，以及Frame Buffer 	

通过Direct Render Manager/Kernel Mode Setting（DRM/KMS）图形渲染架构的内核模式设置，来配置用于显示图像的frame buffer（一块内存区域，存储着输出图像，主函数以及HDMI输出的驱动可以访问它）。

![](<http://ww1.sinaimg.cn/large/ba061518ly1fkx39mievyj20o5092gmf.jpg>)

DRM的结构如上图所示，具体信息可以参考<https://blog.csdn.net/dearsq/article/details/78394388>

1. 将linux中的HDMI显示屏设备，设置为DRI master，为配置KMS做准备。然后得到显示设备的信息，并初始化。

   ```c
   struct drm_mode_card_res res = {0};
   struct drm_mode_get_connector conn = {0};
   struct drm_mode_modeinfo conn_mode_set[30];

   ioctl(fd_card, DRM_IOCTL_SET_MASTER, 0);	/* set as DRI master for KMS setting */
   ioctl(fd_card, DRM_IOCTL_MODE_GETRESOURCES, &res);	/* get resource counts */  	

   // as default, frame buffer device need by created, number of crtc, connector, encoder should be only 1
   fprintf(fd_print, "\nGraphic Info: resource counts\n");
   fprintf(fd_print, "---------------------------------------------\n");
   fprintf(fd_print, "%-32s%u\n","framebuffer number:",res.count_fbs);
   fprintf(fd_print, "%-32s%u\n","crtc number:",res.count_crtcs);
   fprintf(fd_print, "%-32s%u\n","connector number:",res.count_connectors);
   fprintf(fd_print, "%-32s%u\n","encoder number:",res.count_encoders);

   // initialize resource IDs (assuming maximum resource is less than 10)
   uint64_t fb_id_set[10];
   uint64_t crtc_id_set[10];
   uint64_t connector_id_set[10];
   uint64_t encoder_id_set[10];

   memset(fb_id_set,0,sizeof(uint64_t));
   memset(crtc_id_set,0,sizeof(uint64_t));
   memset(connector_id_set,0,sizeof(uint64_t));
   memset(fb_id_set,0,sizeof(uint64_t));

   for (i=0; i<10; i++){
           fb_id_set[i] = (uint64_t) 0;
           crtc_id_set[i] = (uint64_t) 0;
           connector_id_set[i] = (uint64_t) 0;
           encoder_id_set[i] = (uint64_t) 0;
   }

   res.fb_id_ptr = (uint64_t) fb_id_set;
   res.crtc_id_ptr = (uint64_t) crtc_id_set;
   res.connector_id_ptr = (uint64_t) connector_id_set;
   res.encoder_id_ptr = (uint64_t) encoder_id_set;

   ioctl(fd_card, DRM_IOCTL_MODE_GETRESOURCES, &res);

   fprintf(fd_print, "%-32s%u\n","min_width:",res.min_width);
   fprintf(fd_print, "%-32s%u\n","max_width:",res.max_width);
   fprintf(fd_print, "%-32s%u\n","min_height:",res.min_height);
   fprintf(fd_print, "%-32s%u\n","max_height:",res.max_height);
   ```

   ​

2. 得到连接器的信息，初始化，并选择匹配的连接方式，4:3或16:9。

   ```c
   conn.connector_id = connector_id_set[0];

   ioctl(fd_card, DRM_IOCTL_MODE_GETCONNECTOR, &conn);

   // initialize connector (assuming 30 is enough for all connector modes)

   uint64_t conn_prop_set[30];
   uint64_t conn_propval_set[30];
   uint64_t connc_encoder_set[30];

   memset(conn_prop_set, 0, sizeof(uint64_t));
   memset(conn_propval_set, 0, sizeof(uint64_t));
   memset(connc_encoder_set, 0, sizeof(uint64_t));

   conn.modes_ptr = (uint64_t) conn_mode_set;
   conn.props_ptr = (uint64_t) conn_prop_set;
   conn.prop_values_ptr = (uint64_t) conn_propval_set;
   conn.encoders_ptr = (uint64_t) connc_encoder_set;

   ioctl(fd_card, DRM_IOCTL_MODE_GETCONNECTOR, &conn);

   fprintf(fd_print,"%-32s%u\n","mode index:",i);
   fprintf(fd_print,"%-32s%u\n","clock:", conn_mode_set[i].clock);
   fprintf(fd_print,"%-32s%u\n","hdisplay:",conn_mode_set[i].hdisplay);
   fprintf(fd_print,"%-32s%u\n","hsync_start:",conn_mode_set[i].hsync_start);
   fprintf(fd_print,"%-32s%u\n","hsync_end:",conn_mode_set[i].hsync_end);
   fprintf(fd_print,"%-32s%u\n","htotal:",conn_mode_set[i].htotal);
   fprintf(fd_print,"%-32s%u\n","hskew:",conn_mode_set[i].hskew);
   fprintf(fd_print,"%-32s%u\n","vdisplay:",conn_mode_set[i].vdisplay);
   fprintf(fd_print,"%-32s%u\n","vsync_start:",conn_mode_set[i].vsync_start);
   fprintf(fd_print,"%-32s%u\n","vsync_end:",conn_mode_set[i].vsync_end);
   fprintf(fd_print,"%-32s%u\n","vtotal:",conn_mode_set[i].vtotal);
   fprintf(fd_print,"%-32s%u\n","vscan:",conn_mode_set[i].vscan);
   fprintf(fd_print,"%-32s%u\n","vrefresh:",conn_mode_set[i].vrefresh);
   fprintf(fd_print,"%-32s%u\n","flags:",conn_mode_set[i].flags);
   fprintf(fd_print,"%-32s%u\n","type:",conn_mode_set[i].type);
   fprintf(fd_print,"%-32s%s\n\n","name:",conn_mode_set[i].name);

   INT32 mode_index_sel = 7;

   if (osd_width == 1280 && osd_height == 720) {
     mode_index_sel = 7;
   } else if (osd_width == 800 && osd_height == 600) {
     mode_index_sel = 10;
   }
   ```

   ​

3. 创建并配置Frame Buffer。

   ```c
   create_dumb.width = conn_mode_set[mode_index_sel].hdisplay;
   create_dumb.height = conn_mode_set[mode_index_sel].vdisplay;
   create_dumb.bpp = 32;
   create_dumb.flags = 0;
   create_dumb.pitch = 0; // returned value
   create_dumb.size = 0; // returned value
   create_dumb.handle = 0; // returned value

   ioctl(fd_card, DRM_IOCTL_MODE_CREATE_DUMB, &create_dumb)
     
   cmd_dumb.width = create_dumb.width;
   cmd_dumb.height = create_dumb.height;
   cmd_dumb.bpp = create_dumb.bpp;
   cmd_dumb.pitch = create_dumb.pitch;
   cmd_dumb.depth = 24;
   cmd_dumb.handle = create_dumb.handle; 

   ioctl(fd_card, DRM_IOCTL_MODE_ADDFB, &cmd_dumb)
     
   map_dumb.handle = create_dumb.handle;

   ioctl(fd_card, DRM_IOCTL_MODE_MAP_DUMB, &map_dumb)
     
   frame_buffer = (UINT8 *) mmap(0, create_dumb.size, PROT_WRITE, MAP_SHARED, fd_card, map_dumb.offset);
   memset(frame_buffer, 0x80,sizeof(UINT8));
   ```

   ​

4. 显示encode的信息。

   ```c
   enc.encoder_id = conn.encoder_id;

   ioctl(fd_card, DRM_IOCTL_MODE_GETENCODER, &enc);

   fprintf(fd_print, "\nGraphic Info: encoder information\n");
   fprintf(fd_print, "---------------------------------------------\n");
   fprintf(fd_print,"%-32s%u\n","encoder id:",enc.encoder_id);
   fprintf(fd_print,"%-32s%u\n","encoder type:",enc.encoder_type);
   fprintf(fd_print,"%-32s%u\n","crtc_id:",enc.crtc_id);
   fprintf(fd_print,"%-32s%u\n","possible crtcs:",enc.possible_crtcs);
   fprintf(fd_print,"%-32s%u\n\n","possible clones:",enc.possible_clones);
   ```

   ​

5. 配置crtc。

   ```c
   crtc.crtc_id = enc.crtc_id;

   ioctl(fd_card, DRM_IOCTL_MODE_GETCRTC, &crtc);

   fprintf(fd_print, "\nGraphic Info: crtc information\n");
   fprintf(fd_print, "---------------------------------------------\n");
   fprintf(fd_print,"%-32s%llu\n","set_connectors_ptr:",crtc.set_connectors_ptr);
   fprintf(fd_print,"%-32s%u\n","count_connectors:",crtc.count_connectors);
   fprintf(fd_print,"%-32s%u\n","crtc_id:",crtc.crtc_id);
   fprintf(fd_print,"%-32s%u\n","x:",crtc.x);
   fprintf(fd_print,"%-32s%u\n","y:",crtc.y);
   fprintf(fd_print,"%-32s%u\n","gamma_size:",crtc.gamma_size);
   fprintf(fd_print,"%-32s%u\n\n","mode_valid:",crtc.mode_valid);

   crtc.mode_valid = 1;
   crtc.fb_id = cmd_dumb.fb_id;
   crtc.count_connectors = 1;
   crtc.mode = conn_mode_set[mode_index_sel];
   crtc.set_connectors_ptr = (uint64_t) & connector_id_set[0];

   ioctl(fd_card, DRM_IOCTL_MODE_SETCRTC, &crtc)
   ```

   ​

###Step 4 开始网络运算 

首先初始化寄存器的值，将IO Buffer映射到用户空间，并为运算时用到的数据申请内存空间，然后开始网络的运算，并且不断循环从摄像头读取图片，交给网络处理，将结果显示到显示屏的操作。

1. 将DLA的IO Buffer映射到用户空间，为程序向IO Buffer中传递数据做好准备。

   ```c
   volatile void * mapped_dla_iobuf_reg_base;
   volatile void * mapped_dla_iobuf_out_base;
   volatile void * mapped_dla_iobuf_in_base;
   volatile void * mapped_dla_iobuf_wei_base;
   volatile INT32 * p_dla_iobuf_data_out;
   volatile UINT32 * p_dla_iobuf_weight;
   volatile UINT32 * p_dla_iobuf_data_in;
   volatile UINT32 * p_dla_iobuf_regs;

   mapped_dla_iobuf_reg_base = mmap_user(DLA_IOBUF_REG_MAP_SIZE, fd_mem, (UINT32) (DLA_IOBUF_BASE_ADDR+DLA_IOBUF_REGFILE_OFFSET), (UINT32) (DLA_IOBUF_REG_MAP_SIZE-1));
   mapped_dla_iobuf_out_base = mmap_user(DLA_IOBUF_OUT_MAP_SIZE, fd_mem, (UINT32) (DLA_IOBUF_BASE_ADDR+DLA_IOBUF_BURST_OUT_OFFSET), (UINT32) (DLA_IOBUF_OUT_MAP_SIZE-1));
   mapped_dla_iobuf_in_base = mmap_user(DLA_IOBUF_IN_MAP_SIZE,   fd_mem, (UINT32) (DLA_IOBUF_BASE_ADDR+DLA_IOBUF_BURST_IN_OFFSET), (UINT32) (DLA_IOBUF_IN_MAP_SIZE-1));
   mapped_dla_iobuf_wei_base = mmap_user(DLA_IOBUF_WEI_MAP_SIZE, fd_mem, (UINT32) (DLA_IOBUF_BASE_ADDR+DLA_IOBUF_WEIGHT_OFFSET), (UINT32) (DLA_IOBUF_WEI_MAP_SIZE-1));

   p_dla_iobuf_regs = (volatile UINT32 *) mapped_dla_iobuf_reg_base;
   p_dla_iobuf_data_out = (volatile INT32 *) mapped_dla_iobuf_out_base;
   p_dla_iobuf_data_in = (volatile  UINT32 *) mapped_dla_iobuf_in_base;
   p_dla_iobuf_weight = (volatile UINT32 *) mapped_dla_iobuf_wei_base;
   ```

   ​

2. 为运算中会用到的数据申请内存空间，主要是每一层网络的输入图像，以及传给DLA的segment。（这里有三组网络，所有有三组数据）

   ```c
   UINT32 * dla_input_img_segment = (UINT32 *) malloc(sizeof(UINT32) * (43*83*8*6));
   UINT32 * dla_input_img_segment_add0 = (UINT32 *) malloc(sizeof(UINT32) * DLA_BURST_INPUT_SIZE);

   UINT32 * landmark_segment = (UINT32 *) malloc(sizeof(UINT32) * (61*61*8));
   UINT32 * landmark_segment_add0 = (UINT32 *) malloc(sizeof(UINT32) * ((61*61+7)*8));

   UINT32 * third_net_segment = (UINT32 *) malloc(sizeof(UINT32) * (63*63*8));
   UINT32 * third_net_segment_add0 = (UINT32 *) malloc(sizeof(UINT32) * ((63*63+1)*8));
   ```

   ​

3. 初始化IO Buffer中有关握手信号寄存器的值。

   ```c
   dla_reg_init(p_dla_iobuf_regs);
   dla_reg_init_check(fd_print, p_dla_iobuf_regs);
   ```

   ​

4. 从视频采集输出队列中取出包含图像的帧缓冲区，读取出最新的帧图像。

   ```c
   ioctl(fd_video, VIDIOC_DQBUF, &BufferInfo);
   input_data = (UINT8 *) video_buffer[BufferInfo.index];
   ```

   ​

5. 将帧图像从yuyv格式转化为RGB，并传入Frame Buffer，以在显示屏中显示出来。

   ```
   yuyv_2_rgba8888(input_data, frame_buffer, osd_width, osd_height);
   ```

   ​

6. 进行第一个网络前处理，这里包含输入图像转换为gray格式，大小缩放，切成Segment（用于IO Buffer上的传递）。

   ```c
   yuyv_2_gray(input_data, image_data_gray, osd_width, osd_height);
   Imresize_fast(image_shape_input, image_data_gray, image_data);
   Imresize_fast(image_shape_input, image_data_gray, image_data);
   SegmentAdd7Zero(dla_input_img_segment, dla_input_img_segment_add0);
   ```

   ​

7. 等待握手信号**IMG_CPY_DONE_REG_OFFST**为1后，将其清0，然后将segnment传入IO Buffer中的输入区域，传输完毕后再将**IMG_READY_REG_OFFSET**置为1。

   ```c
   if (dla_running == 1 && p_dla_iobuf_regs[IMG_CPY_DONE_REG_OFFST] == 1 && third_net_finish) {
     
   	p_dla_iobuf_regs[IMG_CPY_DONE_REG_OFFST] = 0;
     
     	for (i=0; i<DLA_BURST_INPUT_SIZE; i++) {
           		p_dla_iobuf_data_in[i] = dla_input_img_segment_add0[i];
       }
     
     	p_dla_iobuf_regs[IMG_READY_REG_OFFSET] = 0x1;
   }
   ```

   ​

8. 等待DLA的运算。

   ```c
   while (p_dla_iobuf_regs[RSLT_READY_REG_OFFSET] == 0){
   	;
   }
   ```

   ​

9. 当DLA运算结束，**RSLT_READY_REG_OFFSET**信号为1后，将其清0，然后从IO Buffer的输出区域读取网络运算的结果，进行定点数转浮点数的处理，然后将**RSLT_CPY_DONE_REG_OFFSET**置为1。

   ```c
   if (dla_running == 1 &&  p_dla_iobuf_regs[RSLT_READY_REG_OFFSET] == 1) 	{
   	 
     	p_dla_iobuf_regs[RSLT_READY_REG_OFFSET] = 0;
     
     	for (i=0; i<output_number; i++){
     		net.output[i] = (float) p_dla_iobuf_data_out[offset]/(pow(2,n));
       }
     	
     	p_dla_iobuf_regs[RSLT_CPY_DONE_REG_OFFSET] = 1;
     
   }
   ```

   ​

10. 对网络的结果进行后处理。

   ```c
   net.Postprocess();
   ```

   ​

11. 根据人脸的坐标，在图像上画出人的头像框，将新的结果传回到frame buffer，使显示屏的内容更新。

    ```c
    net.DrawTag(net.ssd_output, frame_buffer);
    ioctl(fd_video, VIDIOC_QBUF, &BufferInfo);
    ```

    ​

12. 如果有第二个或更多的网络的话，则重复6~11步，直到所有网络运算完毕。

    ​

13. 处理完了此帧的运算后，从第4步开始，读取新一帧的图像，并进行运算。

