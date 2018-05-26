import HtmlDecoder.OptimisticDecoderWithBinaryPart

# 1 step
defdecoder(HtmlDecoder.Decoders.BP_8, steps: [8])
defdecoder(HtmlDecoder.Decoders.BP_16, steps: [16])
defdecoder(HtmlDecoder.Decoders.BP_32, steps: [32])
defdecoder(HtmlDecoder.Decoders.BP_64, steps: [64])
# 2 steps
defdecoder(HtmlDecoder.Decoders.BP_16_8, steps: [16, 8])
defdecoder(HtmlDecoder.Decoders.BP_30_10, steps: [30, 10])
defdecoder(HtmlDecoder.Decoders.BP_32_16, steps: [32, 16])
defdecoder(HtmlDecoder.Decoders.BP_36_12, steps: [36, 12])
defdecoder(HtmlDecoder.Decoders.BP_64_32, steps: [64, 32])
defdecoder(HtmlDecoder.Decoders.BP_64_16, steps: [64, 16])
# 3 steps
defdecoder(HtmlDecoder.Decoders.BP_32_16_8, steps: [32, 16, 8])
defdecoder(HtmlDecoder.Decoders.BP_36_12_4, steps: [36, 12, 4])
defdecoder(HtmlDecoder.Decoders.BP_27_9_3, steps: [27, 9, 3])
defdecoder(HtmlDecoder.Decoders.BP_42_14_5, steps: [42, 14, 5])
# 4 steps
defdecoder(HtmlDecoder.Decoders.BP_64_32_16_8, steps: [64, 32, 16, 8])
