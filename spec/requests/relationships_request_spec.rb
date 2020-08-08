require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { create(:user) }
  let(:michael) { create(:user, name: 'michael') }

  describe 'POST /relationships' do
    context 'when not user signed in' do
      it 'can not follow' do
        expect do
          post relationships_path, params: { followed_id: michael.id }
        end.not_to change(Relationship, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      before(:each) { sign_in user }

      context 'when user not follow to michael' do
        it 'user can follow michael' do
          expect do
            post relationships_path, params: { followed_id: michael.id }
          end.to change(Relationship, :count).by(1)
        end
      end

      context 'when user has alredy followed to michael' do
        before(:each) { user.follow(michael) }

        it 'user can not follow michael twice' do
          expect do
            post relationships_path, params: { followed_id: michael.id }
          end.not_to change(Relationship, :count)
          expect(response).to render_template 'users/show'
        end
      end
    end
  end

  describe 'DELETE /relationship/:id' do
    before(:each) do
      user.follow(michael)
      @relationship = user.active_relationships.find_by(followed_id: michael.id)
    end

    context 'when not user signed in' do
      it 'user can not unfollow to michael' do
        expect do
          delete relationship_path(@relationship)
        end.not_to change(Relationship, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      before(:each) { sign_in user }

      it 'user can unfollow michael' do
        expect do
          delete relationship_path(@relationship)
        end.to change(Relationship, :count).by(-1)
      end
    end
  end
end
