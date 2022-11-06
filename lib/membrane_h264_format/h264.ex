defmodule Membrane.H264 do
  @moduledoc """
  This module provides format definition for H264 video stream
  """

  @typedoc """
  Width of single frame in pixels.

  Allowed values may be restricted by used encoding parameters, for example, when using
  4:2:0 chroma subsampling dimensions must be divisible by 2.
  """
  @type width_t :: pos_integer()

  @typedoc """
  Height of single frame in pixels.

  Allowed values may be restricted by used encoding parameters, for example, when using
  4:2:0 chroma subsampling dimensions must be divisible by 2.
  """
  @type height_t :: pos_integer()

  @typedoc """
  Number of frames per second. To avoid using floating point numbers,
  it is described by 2 integers number of frames per timeframe in seconds.

  For example, NTSC's framerate of ~29.97 fps is represented by `{30_000, 1001}`
  """
  @type framerate_t :: {frames :: pos_integer, seconds :: pos_integer}

  @typedoc """
  Describes h264 stream format.

  `:anexb` (defined in Annex B of [ITU-T H.264 Recommendation](http://www.itu.int/rec/T-REC-H.264-201704-I/en))
  is suitable for writing to a file or streaming with MPEG-TS.
  In this format each NAL unit is preceded by three or four-byte start code (`0x(00)000001`)
  that helps to identify boundaries.

  `:length_prefix` is described by ISO/IEC 14496-15. In such stream NALUs lack the start codes,
  but are preceded with their length. `:length_prefix` streams are more suitable for placing in containers
  (e.g. they are used by QuickTime (.mov), MP4, Matroska and FLV).
  """
  @type nalu_format_t :: :anexb | :length_prefix

  @typedoc """
  Describes whether and how buffers are aligned.

  `:au` means each buffer contains one Access Unit - all the NAL units required to decode
  a single frame of video

  `:nalu` aligned stream ensures that no NAL unit is split between buffers, but it is possible that
  NALUs required for one frame are in different buffers
  """
  @type alignment_t :: :au | :nalu

  @typedoc """
  When alignment is set to `:au`, determines whether buffers have NALu info attached in metadata.

  If true, each buffer contains the NAL units list under `metadata.h264.nalus`. The list consists of
  maps with the following entries:
  - `prefixed_poslen: {pos, len}` - position and length of the NALu within the payload
  - `unprefixed_poslen: {pos, len}` - as above, but omits Annex B prefix
  - `metadata: metadata` - metadata that would be merged into the buffer metadata
    if `alignment` was `:nal`.
  """
  @type nalu_in_metadata_t :: boolean()

  @typedoc """
  Profiles defining constraints for encoders and requirements from decoders decoding such stream
  """
  @type profile_t ::
          :constrained_baseline
          | :baseline
          | :main
          | :high
          | :high_10
          | :high_422
          | :high_444
          | :high_10_intra
          | :high_422_intra
          | :high_444_intra

  @type t :: %__MODULE__{
          width: width_t(),
          height: height_t(),
          framerate: framerate_t(),
          nalu_format: nalu_format_t(),
          alignment: alignment_t(),
          nalu_in_metadata?: nalu_in_metadata_t(),
          profile: profile_t()
        }

  @enforce_keys [:width, :height, :framerate, :nalu_format, :profile]
  defstruct @enforce_keys ++ [alignment: :au, nalu_in_metadata?: false]
end
