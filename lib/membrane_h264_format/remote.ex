defmodule Membrane.H264.RemoteStream do
  @moduledoc """
  Format definition for packetized, remote H264 video streams.

  Examples of such a stream:
  * H264 depayloaded from a container like FLV, where
  decoder configuration is signalled outside of the H264 bytestream.
  * H264 depayloaded from an RTP stream which is always aligned to
  NAL units.
  """
  @enforce_keys [:alignment, :nalu_format]
  defstruct [:decoder_configuration_record] ++ @enforce_keys

  @type t() :: %__MODULE__{
          alignment: Membrane.H264.alignment_t(),
          decoder_configuration_record: binary() | nil,
          nalu_format: Membrane.H264.nalu_format_t()
        }
end
