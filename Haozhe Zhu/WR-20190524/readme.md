# Weekly Report (Sat, May 25, 2019)

## Continue Neural Network Quantization

1. IBM LSQ porting. Move the quantization layer behind the ReLU layer.

```python
class LsqQuanAct(t.autograd.Function):
    @staticmethod
    def forward(ctx, x, s, nbit):
        nlevel = 2 ** (nbit - 1) - 1
        x_scale = x / s
        x_bin = x_scale.clamp(-nlevel, nlevel).round()
        y = x_bin * s
        ctx.save_for_backward(x, s)
        ctx.nLevel = nlevel
        return y

    @staticmethod
    def backward(ctx, grad_y):
        x, s = ctx.saved_tensors
        nlevel = ctx.nLevel
        x_scale = x / s
        x_isclip = abs(x_scale).lt(nlevel)
        x_bin = x_scale.clamp(-nlevel, nlevel).round()

        grad_x = grad_s = None
        if ctx.needs_input_grad[0]:  # dy/dx
            grad_x = t.where(x_isclip, grad_y, t.zeros_like(grad_y))
        if ctx.needs_input_grad[1]:  # dy/ds
            grad_s = t.sum(t.where(x_isclip, x_scale.round() - x_scale, x_bin) * grad_y).unsqueeze(0)
        return grad_x, grad_s, None


class LsqQuanWeight(t.autograd.Function):
    @staticmethod
    def forward(ctx, x, s, nbit):
        nlevel = 2 ** (nbit - 1) - 1
        x_scale = x / s
        x_bin = x_scale.clamp(-nlevel, nlevel).round()
        y = x_bin * s
        ctx.save_for_backward(x, s)
        ctx.nLevel = nlevel
        return y

    @staticmethod
    def backward(ctx, grad_y):
        x, s = ctx.saved_tensors
        nlevel = ctx.nLevel
        x_scale = x / s
        x_isclip = abs(x_scale).lt(nlevel)
        x_clip_round = x_scale.clamp(-nlevel, nlevel).round()

        grad_x = grad_s = None
        if ctx.needs_input_grad[0]:  # dy/dx
            grad_x = grad_y
        if ctx.needs_input_grad[1]:  # dy/ds
            grad_s = t.sum(t.where(x_isclip, x_scale.round() - x_scale, x_clip_round) * grad_y).unsqueeze(0)
        return grad_x, grad_s, None
```

2. Try some new ideas.
  - keep the partial sum away from fixed-pointed rounding center

3. Studying the clock domain crossing technology in the ASIC flow. 

