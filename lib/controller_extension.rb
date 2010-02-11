class ActionController::Base
  def process_with_less(*args)
    Less::More.generate_all
    process_without_less(*args)
  end

  alias_method_chain :process, :less
end