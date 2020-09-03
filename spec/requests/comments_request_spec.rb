require 'rails_helper'

RSpec.xdescribe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:surplus_land) { create(:surplus_land, state: '東京都', user: user) }

  before(:each) { create(:prefecture) }

  describe "POST /surplus_lands/:surplus_land_id/comments" do
    let(:params) do
      {
        comment: {
          body: body,
          user_id: user.id,
          surplus_land_id: surplus_land.id,
        }
      }
    end

    context 'when not user signed in' do
      let(:body) { 'Example_Comment' }

      it 'failed to create comments' do
        expect do
          post surplus_land_comments_path(surplus_land), params: params
        end.not_to change(Comment, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      before(:each) { sign_in user }

      context 'params is invalid' do
        context 'body is blank' do
          let(:body) { '' }

          it 'failed to create comments' do
            expect do
              post surplus_land_comments_path(surplus_land), params: params
            end.not_to change(Comment, :count)
            expect(response).to render_template 'surplus_lands/show'
          end
        end

        context 'body is too long' do
          let(:body) { 'comment' * 58 }

          it 'failed to create comments' do
            expect do
              post surplus_land_comments_path(surplus_land), params: params
            end.not_to change(Comment, :count)
            expect(response).to render_template 'surplus_lands/show'
          end
        end
      end

      context 'params is valid' do
        let(:body) { 'Valid_Comment' }

        it 'success to create comments' do
          expect do
            post surplus_land_comments_path(surplus_land), params: params
          end.to change(Comment, :count).by(1)
        end
      end
    end
  end

  describe 'DELETE /surplus_lands/:surplus_land_id/comments/:id' do
    let!(:comment) { create(:comment, surplus_land: surplus_land, user: user) }

    context 'when not user signed in' do
      it 'can not delete comments' do
        expect do
          delete surplus_land_comment_path(surplus_land, comment)
        end.not_to change(Comment, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user signed in' do
      context 'when not correct user' do
        let(:other_user) { create(:user) }

        before(:each) { sign_in other_user }

        it 'other_user should not delete users-comment' do
          expect do
            delete surplus_land_comment_path(surplus_land, comment)
          end.not_to change(Comment, :count)
          expect(response).to redirect_to root_url
        end
      end

      context 'when correct user' do
        before(:each) { sign_in user }

        it 'success to delete comment' do
          expect do
            delete surplus_land_comment_path(surplus_land, comment)
          end.to change(Comment, :count).by(-1)
        end
      end
    end
  end
end
