require 'capybara'
require 'capybara/rspec'

Capybara.default_driver = :selenium_chrome

RSpec.describe 'Smoke test', type: :feature do

    it 'search page' do
      visit 'https://www.navigator.ba/#/categories'
      expect(page).to have_text('SARAJEVO')
    end

    it 'search place' do
      visit 'https://www.navigator.ba/#/categories'
      fill_in "Traži ulicu ili objekat", with: 'Kamerni teatar 55'
      find('.iconav-search').click
      find('.mCSB_container').click
      expect(page).to have_link 'www.kamerniteatar55.ba'
      expect(page).to have_css '.leaflet-popup'
    end

    it 'send message' do
      visit 'https://www.navigator.ba/#/categories'
      find('#ember581').click
      fill_in "Ime i prezime", with: 'Medzida Mustafic'
      fill_in "Email", with: 'medzidamustafic@gmail.com'
      fill_in "Komentar", with: 'I like it!'
      find('.green').click
      click_button 'Pošalji'
      expect(page).to have_content "Hvala na poruci! Potrudit ćemo se da što prije reagujemo."
    end

   it 'create place' do
      visit 'https://www.navigator.ba/#/categories'
      find('#ember566').click
      fill_in 'poi_name', with: 'Biljna apoteka'
      fill_in "poi_city_name", with: 'Sarajevo'
      fill_in "poi_zip_code", with: '71000'
      fill_in "poi_place_id", with: 'Aleja Lipa'
      fill_in "poi_house_number", with: '33'
      fill_in "poi_description", with: 'Domaća biljna apoteka'
      find_button('Odaberite kategoriju').click
      find('.span3 option[value="11"]').select_option
      find('.span3 option[value="203"]').select_option
      execute_script("arguments[0].scrollBy(84,294);", page.find("button.btn-success", visible: false).native)
      click_button 'Kreiraj'
      expect(page).to have_css ".leaflet-popup"
    end

end    