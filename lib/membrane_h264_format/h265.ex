defmodule Membrane.H265 do
  @moduledoc """
  This module provides format definition for H265 video stream
  """

  alias Membrane.H26x.Types

  @typedoc """
  Describes H265 stream structure.

  Annex B (ITU-T H.265 Recommendation)
  is suitable for writing to file or streaming with MPEG-TS.
  In this format each NAL unit is prefixed by three or four-byte start code (`0x(00)000001`)
  that allows to identify boundaries between them.

  hvc1 and hev1 are described by ISO/IEC 14496-15. In such stream a DCR (Decoder Configuration
  Record) is included out-of-band and NALUs lack the start codes, but are prefixed with their length.
  The length of these prefixes is contained in the stream's DCR. HEVC streams are more suitable for
  placing in containers (e.g. they are used by QuickTime (.mov), MP4, Matroska and FLV).
  In hvc1 streams PPSs, SPSs and VPSs (Picture Parameter Sets, Sequence Parameter Sets and Video Parameter Sets respectively)
  are transported in the DCR, when in hev1 they may be also present in the stream (in-band).
  """
  @type stream_structure :: :annexb | {:hvc1 | :hev1, dcr :: binary()}

  @typedoc """
  Profiles defining constraints for encoders and requirements from decoders decoding such stream
  """
  @type profile ::
          :main
          | :main_10
          | :main_still_picture
          | :rext

  @typedoc """
  Format definition for H265 video stream.
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
  Checks if stream structure is `:hvc1` or `:hev1`
  """
  defguard is_hevc(stream_structure)
           when tuple_size(stream_structure) == 2 and elem(stream_structure, 0) in [:hvc1, :hev1]
end
