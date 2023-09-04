defmodule Membrane.H264 do
  @moduledoc """
  This module provides format definition for H264 video stream
  """

  @typedoc """
  Width of single frame in pixels.

  Allowed values may be restricted by used encoding parameters, for example, when using
  4:2:0 chroma subsampling dimensions must be divisible by 2. If the information about the
  width is not present in the stream, `nil` value should be used.
  """
  @type width :: pos_integer()

  @typedoc """
  Height of single frame in pixels.

  Allowed values may be restricted by used encoding parameters, for example, when using
  4:2:0 chroma subsampling dimensions must be divisible by 2. If the information about the
  height is not present in the stream, `nil` value should be used.
  """
  @type height :: pos_integer()

  @typedoc """
  Number of frames per second. To avoid using floating point numbers,
  it is described by 2 integers number of frames per timeframe in seconds.

  For example, NTSC's framerate of ~29.97 fps is represented by `{30_000, 1001}`
  If the information about the framerate is not present in the stream, `nil` value
  should be used.
  """
  @type framerate :: {frames :: pos_integer(), seconds :: pos_integer()} | nil

  @typedoc """
  Describes whether and how buffers are aligned.

  `:au` means each buffer contains one Access Unit - all the NAL units required to decode
  a single frame of video

  `:nalu` aligned stream ensures that no NAL unit is split between buffers, but it is possible that
  NALUs required for one frame are in different buffers
  """
  @type alignment :: :au | :nalu

  @typedoc """
  When alignment is set to `:au`, determines whether buffers have NALu info attached in metadata.

  If true, each buffer contains the NAL units list under `metadata.h264.nalus`. The list consists of
  maps with the following entries:
  - `prefixed_poslen: {pos, len}` - position and length of the NALu within the payload
  - `unprefixed_poslen: {pos, len}` - as above, but omits Annex B or AVC prefix
  - `metadata: metadata` - metadata that would be merged into the buffer metadata
    if `alignment` was `:nalu`.
  """
  @type nalu_in_metadata :: boolean()

  @typedoc """
  Describes H264 stream structure.

  Annex B ([ITU-T H.264 Recommendation](http://www.itu.int/rec/T-REC-H.264-201704-I/en))
  is suitable for writing to file or streaming with MPEG-TS.
  In this format each NAL unit is prefixed by three or four-byte start code (`0x(00)000001`)
  that allows to identify boundaries between them.

  avc1 and avc3 are described by ISO/IEC 14496-15. In such stream a DCR (Decoder Configuration
  Record) is included out-of-band and NALUs lack the start codes, but are prefixed with their length.
  The length of these prefixes is contained in the stream's DCR. AVC streams are more suitable for
  placing in containers (e.g. they are used by QuickTime (.mov), MP4, Matroska and FLV).
  In avc1 streams PPSs and SPSs (Picture Parameter Sets and Sequence Parameter Sets) are
  transported in the DCR, when in avc3 they may be also present in the stream (in-band).
  """
  @type stream_structure :: :annexb | {:avc1 | :avc3, dcr :: binary()}

  @typedoc """
  Profiles defining constraints for encoders and requirements from decoders decoding such stream
  """
  @type profile ::
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

  @typedoc """
  Format definition for H264 video stream.
  """
  @type t :: %__MODULE__{
          width: width(),
          height: height(),
          framerate: framerate(),
          alignment: alignment(),
          nalu_in_metadata?: nalu_in_metadata(),
          profile: profile(),
          stream_structure: stream_structure()
        }

  defstruct width: nil,
            height: nil,
            profile: nil,
            alignment: :au,
            nalu_in_metadata?: false,
            framerate: nil,
            stream_structure: :annexb

  @doc """
  Checks if stream structure is :avc1 or :avc3
  """
  defguard is_avc(stream_structure)
           when tuple_size(stream_structure) == 2 and elem(stream_structure, 0) in [:avc1, :avc3]
end
