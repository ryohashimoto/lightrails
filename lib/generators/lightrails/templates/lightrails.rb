Rails.application.config.eager_load_paths += [
  Rails.root.join("app", "facades").to_s,
  Rails.root.join("app", "interactors").to_s,
  Rails.root.join("app", "representers").to_s
]
