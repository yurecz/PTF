interface IF_APOC_PTF_BO_PREPARATION
  public .

  METHODS:

    prepare_root_data
      RETURNING VALUE(roots_to_create) TYPE apoc_t_or_root.

endinterface.
