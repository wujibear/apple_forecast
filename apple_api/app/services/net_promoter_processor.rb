class NetPromoterProcessor
    DATA =[
            {"rating": 10, "message": "Always great service and food"},
            {"rating": 10, "message": "Great food."},
            {"rating": 9, "message": "Fresh and healthy"},
            {"rating": 10, "message": "The Parker salad is PHENOMENAL. The best fresh salads."},
            {"rating": 10, "message": "Wish your black beans, roasted broccoli and butternut squash with kale aren't spicy.   It's common that some people like me just can't have chili flakes or spicy essence.  It's too bad.   I go there regularly.  That limits my selection.  Hope someday you'll adjust."},
            {"rating": 10, "message": "Fresh ingredients and friendly people."},
            {"rating": 10, "message": "Great"},
            {"rating": 3, "message": "The order was not ready when I arrived- 5 mins after 1145 - the greeter was kind and said they were backed up and to come back in 20 mins. \n\nThe radishes were soaking wet and made the whole salad watery- probably the worst salad I’ve had so far. I’ll come again but will order something else and maybe wait in line instead of online order. "},
            {"rating": 10, "message": "Quick service and fresh ingredients. "},
            {"rating": 10, "message": "Great!"},
            {"rating": 10, "message": "Amazing food!"},
            {"rating": 5, "message": "For some reason the salad wasn’t as good today, different dressing or ingredients weren’t as fresh as usual? Couldn’t place it but was definitely worse than usual "},
            {"rating": 6, "message": "You need to add employees. Now that more staff is handling email orders, the line moves very slowly"},
            {"rating": 8, "message": "FRESh"},
            {"rating": 10, "message": "Really nice folks  at Sansome locale"},
            {"rating": 2, "message": "You lost your best salad maker and the new ppl just aren't as good. They are not trained on how to make a good salad and the quality drop off is noticeable "},
            {"rating": 2, "message": "Terribly slow service"},
            {"rating": 10, "message": "Good job "},
            {"rating": 9, "message": "Fresh ingredients "},
            {"rating": 7, "message": "Ha"},
            {"rating": 9, "message": "I like the salads they are just so expensive "},
            {"rating": 10, "message": "Yum "},
            {"rating": 10, "message": "Good food"},
            {"rating": 9, "message": "Fast and accurate service"},
            {"rating": 7, "message": "So good but So expensive "},
            {"rating": 10, "message": "Fast. Delicious. "},
            {"rating": 10, "message": "Always fresh and delicious. "},
            {"rating": 8, "message": "Out of avocado "},
            {"rating": 1, "message": "Long lines, 8 staff, 2 helping people in line"},
            {"rating": 7, "message": "The staff was overwhelmed by mobile orders. Not enough raw vegetables available to customize a salad."}
          ]

    attr_reader :keywords

    def initialize
        @keywords = ['service', 'chicken', 'cookie', 'food', 'salad']
    end

    def result
        @result ||= keywords.each_with_object({}) do |keyword, result|
            result[keyword] = KeywordSearch.new(keyword, DATA).net_promoter_score
        end
    end

    # PromoterCache, keyword, number_of_records, number_of_promoters, number_of_detractors, number_of_passives, timestamp


    class KeywordSearch
        attr_reader :keyword, :data

        def initialize(keyword, data)
            @keyword = keyword
            @data = data
        end

        def matching_records
            @matching_records ||= data.select { |item| item[:message].include?(keyword) }
        end

        def net_promoter_score
            p [:promoters, promoters.count, promoters]
            p [:detractors, detractors.count, detractors]
            promotion_percentage = (promoters.count.to_f / matching_records.count) * 100
            detractor_percentage = (detractors.count.to_f / matching_records.count) * 100

            promotion_percentage - detractor_percentage
        end

        def promoters 
            @promoters ||= matching_records.select { |item| item[:rating] >= 9 }
        end

        def detractors
            @detractors ||= matching_records.select { |item| item[:rating] <= 6 }
        end

        def passives
            matching_records.select { |item| item[:rating] >= 7 && item[:rating] <= 8 }
        end

    end
end

# m keywords, n feedbacks
# m * n2