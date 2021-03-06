require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #new' do
    it 'renders the new user\'s page' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'logs in the user' do
        post :create, params: { user: {username: 'user', password: 'password'}}
        user = User.find_by(username: 'user')
        expect(session[:session_token]).to eq(user.session_token)
      end
      it 'redirects to user\'s show page' do
        post :create, params: { user: {username: 'user', password: 'password'}}
        user = User.find_by(username: 'user')
        expect(response).to redirect_to(user_url(user))
      end
    end
    context 'with invalid params' do
      it 'validates presence of password and renders new template' do
        post :create, params: { user: {username: 'user'}}
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
      it 'validates presence of username and renders new template' do
        post :create, params: { user: {password: 'password'}}
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end
  end
end
