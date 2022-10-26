require 'rails_helper'

RSpec.describe 'Landing Page' do
  describe 'When a user visits the root path' do
    let!(:users) { create_list(:user, 3) }
    let!(:user1) { users.first }

    before :each do
      visit root_path
    end


    it 'should be on the landing page with title' do
      expect(page).to have_content('Viewing Party')
    end

    it 'should have button to create a new user' do
      expect(page).to have_button('Create New User')

      click_button 'Create New User'

      expect(current_path).to eq(register_path)
    end

    it 'has section for existing users when logged in' do
      expect(page).to_not have_content('Existing Users')
      click_on 'Login'

      fill_in 'Enter Email', with: user1.email
      fill_in 'Enter Password', with: user1.password

      click_on 'Login'
      click_on 'Home'

      expect(page).to have_content('Existing Users')

      within("#existing_users") do
        within("#user-#{user1.id}") do
          expect(page).to have_content("#{user1.email}")
        end
        within("#user-#{users.second.id}") do
          expect(page).to have_content("#{users.second.email}")
        end
        within("#user-#{users.third.id}") do
          expect(page).to have_content("#{users.third.email}")
        end
      end
    end

    it 'has a home link at top of page' do
      expect(page).to have_link('Home')

      click_link 'Home'

      expect(current_path).to eq(root_path)
    end
  end
end
