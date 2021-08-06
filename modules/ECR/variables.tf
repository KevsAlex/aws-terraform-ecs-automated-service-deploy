variable services {

  type = list(map(string))
  default = [
    {
      name = "image-1234",
      port = 8421
    }
  ]
}


