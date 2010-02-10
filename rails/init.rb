config.after_initialize {
  Less::More.clean
  Less::More.parse if Less::More.page_cache?
}