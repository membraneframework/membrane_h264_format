defmodule Membrane.H264 do
  @moduledoc """
  This module provides format definition for H264 video stream
  """

  alias Membrane.H26x.Types

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
          | nil

  @typedoc """
  Format definition for H264 video stream.
  """
  @type t :: %__MODULE__{
          width: Types.width(),
          height: Types.height(),
          framerate: Types.framerate(),
          alignment: Types.alignment(),
          nalu_in_metadata?: Types.nalu_in_metadata(),
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
