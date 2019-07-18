class Api::V1::CompoundsController < ApplicationController
    def create
        @compound = Compound.create(compound_params)
    end


    private

    def compound_params
        params.require(:compound)
    end
end
