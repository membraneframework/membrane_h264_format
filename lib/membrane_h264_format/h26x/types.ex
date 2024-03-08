defmodule Membrane.H26x.Types do
  @moduledoc """
  Defines common types for H26x video fromat.
  """

  @typedoc """
  Width of single frame in pixels.

  Allowed values may be restricted by used encoding parameters, for example, when using
  4:2:0 chroma subsampling dimensions must be divisible by 2. If the information about the
  width is not present in the stream, `nil` value should be used.
  """
  @type width :: pos_integer() | nil

  @typedoc """
  Height of single frame in pixels.

  Allowed values may be restricted by used encoding parameters, for example, when using
  4:2:0 chroma subsampling dimensions must be divisible by 2. If the information about the
  height is not present in the stream, `nil` value should be used.
  """
  @type height :: pos_integer() | nil

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
  - `unprefixed_poslen: {pos, len}` - as above, but omits Annex B or AVC/HEVC prefix
  - `metadata: metadata` - metadata that would be merged into the buffer metadata
    if `alignment` was `:nalu`.
  """
  @type nalu_in_metadata :: boolean()
end
