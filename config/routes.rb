Spree::Core::Engine.routes.append do  
  namespace :admin do
    resources :reports, :only => [:index, :show] do  # <= add this block
      collection do
        get :product_sales
        post :product_sales
      end
    end
  end
end
