defmodule Membrane.RemoteStream.H264 do
  @moduledoc """
  Format definition for H264 video streams with decoder configuration transmitted out of band.

  Example of such a stream is H264 depayloaded from a container like MP4 or FLV, where decoder configuration is signalled outside of the H264 bytestream.
  """
  @enforce_keys [:decoder_configuration_record, :stream_format]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          decoder_configuration_record: binary(),
          stream_format: Membrane.H264.stream_format_t()
        }
end
