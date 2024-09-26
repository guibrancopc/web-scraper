class AddLastResultToPages < ActiveRecord::Migration[7.1]
  def change
    add_column :pages, :last_result_id, :integer

    Page.find_each do |page|
      page.update(last_result: page.results.last)
    end
  end
end
