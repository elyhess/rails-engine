Rails.application.routes.draw do
	namespace :api do
		namespace :v1 do
			namespace :items do
				get 'find_all', to: 'search#index'
			end
			namespace :merchants do
				get 'find', to: 'search#index'
				get 'most_revenue', to: 'revenue#index'
				get 'total_revenue', to: 'revenue#show'
				get 'most_items', to: 'most_items#index'
			end
			resources :items do
				get '/merchant', to: 'items/merchant#index'
			end
			resources :merchants, only: [:index, :show] do
				get '/items', to: 'merchants/items#index'
			end
			get '/revenue', to: 'revenue#index'
			namespace :revenue do
				resources :merchants, only: [:show]
			end
		end
	end
end
