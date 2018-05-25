import HtmlDecoder.OptimisticDecoderWithBinaryPart

# 1 step
defdecoder HtmlDecoder.Decoders.BP_8, steps: [8]
defdecoder HtmlDecoder.Decoders.BP_16, steps: [16]
defdecoder HtmlDecoder.Decoders.BP_32, steps: [32]
# 2 steps
defdecoder HtmlDecoder.Decoders.BP_16_8, steps: [16, 8]
defdecoder HtmlDecoder.Decoders.BP_32_16, steps: [32, 16]
# 3 steps
defdecoder HtmlDecoder.Decoders.BP_32_16_8, steps: [32, 16, 8]