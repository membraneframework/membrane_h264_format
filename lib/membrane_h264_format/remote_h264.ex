defmodule Membrane.RemoteStream.H264 do
  @moduledoc """
  RemoteStream caps transporting H264 video
  """
  @enforce_keys [:decoder_configuration_record]
  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          decoder_configuration_record: binary()
        }

  @spec parse!(t()) :: Membrane.H264.DecoderConfiguration.t()
  def parse!(%__MODULE__{decoder_configuration_record: dcr}) do
    {:ok, result} = Membrane.H264.DecoderConfiguration.parse(dcr)
    result
  end
end
