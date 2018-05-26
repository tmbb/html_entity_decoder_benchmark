import HtmlDecoder.OptimisticDecoderWithCharlist

# 1 step
defdecoder(HtmlDecoder.Decoders.CL_8, steps: [8])
defdecoder(HtmlDecoder.Decoders.CL_16, steps: [16])
defdecoder(HtmlDecoder.Decoders.CL_32, steps: [32])
# 2 steps
defdecoder(HtmlDecoder.Decoders.CL_16_8, steps: [16, 8])
defdecoder(HtmlDecoder.Decoders.CL_32_16, steps: [32, 16])
# 3 steps
defdecoder(HtmlDecoder.Decoders.CL_32_16_8, steps: [32, 16, 8])
