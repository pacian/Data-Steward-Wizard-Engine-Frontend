module Shared.Data.EditableConfig.EditableQuestionnairesConfig exposing
    ( EditableQuestionnairesConfig
    , decoder
    , encode
    )

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import Json.Encode as E
import Shared.Data.BootstrapConfig.Partials.SimpleFeatureConfig as SimpleFeatureConfig exposing (SimpleFeatureConfig)
import Shared.Data.EditableConfig.EditableQuestionnaireConfig.EditableQuestionnaireSharingConfig as EditableQuestionnaireSharingConfig exposing (EditableQuestionnaireSharingConfig)
import Shared.Data.EditableConfig.EditableQuestionnaireConfig.EditableQuestionnaireVisibilityConfig as EditableQuestionnaireVisibilityConfig exposing (EditableQuestionnaireVisibilityConfig)


type alias EditableQuestionnairesConfig =
    { questionnaireVisibility : EditableQuestionnaireVisibilityConfig
    , questionnaireSharing : EditableQuestionnaireSharingConfig
    , levels : SimpleFeatureConfig
    , feedback : Feedback
    , summaryReport : SimpleFeatureConfig
    }


type alias Feedback =
    { enabled : Bool
    , token : String
    , owner : String
    , repo : String
    }


decoder : Decoder EditableQuestionnairesConfig
decoder =
    D.succeed EditableQuestionnairesConfig
        |> D.required "questionnaireVisibility" EditableQuestionnaireVisibilityConfig.decoder
        |> D.required "questionnaireSharing" EditableQuestionnaireSharingConfig.decoder
        |> D.required "levels" SimpleFeatureConfig.decoder
        |> D.required "feedback" feedbackDecoder
        |> D.required "summaryReport" SimpleFeatureConfig.decoder


feedbackDecoder : Decoder Feedback
feedbackDecoder =
    D.succeed Feedback
        |> D.required "enabled" D.bool
        |> D.required "token" D.string
        |> D.required "owner" D.string
        |> D.required "repo" D.string


encode : EditableQuestionnairesConfig -> E.Value
encode config =
    E.object
        [ ( "questionnaireVisibility", EditableQuestionnaireVisibilityConfig.encode config.questionnaireVisibility )
        , ( "questionnaireSharing", EditableQuestionnaireSharingConfig.encode config.questionnaireSharing )
        , ( "levels", SimpleFeatureConfig.encode config.levels )
        , ( "feedback", encodeFeedback config.feedback )
        , ( "summaryReport", SimpleFeatureConfig.encode config.summaryReport )
        ]


encodeFeedback : Feedback -> E.Value
encodeFeedback feedback =
    E.object
        [ ( "enabled", E.bool feedback.enabled )
        , ( "token", E.string feedback.token )
        , ( "owner", E.string feedback.owner )
        , ( "repo", E.string feedback.repo )
        ]
