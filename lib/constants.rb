module Constants
  module Admin
    PRIVILEGES = {
      create_promo: 1 << 0,
      update_promo: 1 << 1,
      delete_promo: 1 << 2,
      update_branch: 1 << 3,
      invite_to_branch: 1 << 4
    }
  end

  module Branch
    DEFAULT_BRANCH_NEARNESS_KM = 3
  end
end
