Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	root 'welcome#welcome'
	post '/', to: 'welcome#message'
	post 'void', to: 'welcome#void'
end
