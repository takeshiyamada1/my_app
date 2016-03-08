require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  let(:user) { create :tsubasa }
  context 'create action' do
    context 'create micropost' do
      before do
        log_in_as(user)
      end
      it 'should redirec create micropost' do
        expect { post :create, micropost: { content: 'micropost create' } }.to change { Micropost.count}.by(1)
        expect(flash).to be_present
        expect(response).to redirect_to root_url
      end
    end
    context 'when not logged in' do
      it 'should redirect create when not logged in' do
        expect { post :create, micropost: { content: 'Lorem ipsum' } }.to_not change { Micropost.count }
        expect(response).to redirect_to login_url
      end
    end
    context 'create not micropost' do
      before do
        log_in_as(user)
      end
      it 'should no create micropost' do
        expect { post :create, micropost: { content: 'a'*141 } }.to_not change  { Micropost.count }
        expect(response).to render_template 'static_pages/home'
      end
    end
  end

  context 'destroy action' do
    let(:user_microposts) { create :tsubasa_with_microposts }
    context 'destroy micropost' do
      before do
        log_in_as(user)
        user_microposts
      end
      it 'should redirect destroy for wrong micropost' do
        expect { delete :destroy, id: user_microposts }.to change { Micropost.count }.by(-1)
        expect(response).to redirect_to root_url
        expect(flash).to be_present
      end
    end

    context 'when not logged in' do
      before do
        user_microposts
      end
      it 'should redirect destroy when not logged in' do
        expect { delete :destroy, id: user_microposts }.to_not change { Micropost.count }
        expect(response).to redirect_to login_url
      end
    end

    context 'without micropost' do
      let(:other) { create :mallory }
      before do
        log_in_as(other)
        user_microposts
      end
      it 'should redirect destroy for wrong micropost' do
        expect { delete :destroy, id: user_microposts }.to_not change { Micropost.count }
        expect(response).to redirect_to root_url
      end
    end
  end
end