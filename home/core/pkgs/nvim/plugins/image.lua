require("image").setup{
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" }
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = false,
      only_render_image_at_cursor = false,
      filetypes = { "norg" }
    }
  }
}
