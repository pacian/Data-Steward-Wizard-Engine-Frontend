module Wizard.KMEditor.Editor.KMEditor.Update.KnowledgeModel exposing
    ( addChapter
    , addIntegration
    , addTag
    , updateKMForm
    , withGenerateKMEditEvent
    )

import Form
import Random exposing (Seed)
import Shared.Data.KnowledgeModel.Chapter as Chapter
import Shared.Data.KnowledgeModel.Integration as Integration
import Shared.Data.KnowledgeModel.Tag as Tag
import Shared.Locale exposing (l)
import Wizard.Common.AppState exposing (AppState)
import Wizard.KMEditor.Editor.KMEditor.Models exposing (Model, getCurrentIntegrations)
import Wizard.KMEditor.Editor.KMEditor.Models.Editors exposing (..)
import Wizard.KMEditor.Editor.KMEditor.Models.Forms exposing (knowledgeModelFormValidation)
import Wizard.KMEditor.Editor.KMEditor.Update.Abstract exposing (addEntity, updateForm, withGenerateEvent)
import Wizard.KMEditor.Editor.KMEditor.Update.Events exposing (createEditKnowledgeModelEvent)
import Wizard.Msgs


l_ : String -> AppState -> String
l_ =
    l "Wizard.KMEditor.Editor.KMEditor.Update.KnowledgeModel"


updateKMForm : Model -> Form.Msg -> KMEditorData -> Model
updateKMForm =
    updateForm
        { formValidation = knowledgeModelFormValidation
        , createEditor = KMEditor
        }


withGenerateKMEditEvent : AppState -> Seed -> Model -> KMEditorData -> (Seed -> Model -> KMEditorData -> ( Seed, Model, Cmd Wizard.Msgs.Msg )) -> ( Seed, Model, Cmd Wizard.Msgs.Msg )
withGenerateKMEditEvent appState =
    withGenerateEvent
        { isDirty = isKMEditorDirty
        , formValidation = knowledgeModelFormValidation
        , createEditor = KMEditor
        , alert = l_ "alert" appState
        , createAddEvent = createEditKnowledgeModelEvent
        , createEditEvent = createEditKnowledgeModelEvent
        , updateEditorData = updateKMEditorData
        , updateEditors = Nothing
        }


addChapter : Cmd Wizard.Msgs.Msg -> Seed -> Model -> KMEditorData -> ( Seed, Model, Cmd Wizard.Msgs.Msg )
addChapter cmd seed model =
    addEntity
        { newEntity = Chapter.new
        , createEntityEditor = createChapterEditor (getCurrentIntegrations model)
        , addEntity = addKMChapter
        }
        cmd
        seed
        model


addTag : Cmd Wizard.Msgs.Msg -> Seed -> Model -> KMEditorData -> ( Seed, Model, Cmd Wizard.Msgs.Msg )
addTag =
    addEntity
        { newEntity = Tag.new
        , createEntityEditor = createTagEditor
        , addEntity = addKMTag
        }


addIntegration : Cmd Wizard.Msgs.Msg -> Seed -> Model -> KMEditorData -> ( Seed, Model, Cmd Wizard.Msgs.Msg )
addIntegration =
    addEntity
        { newEntity = Integration.new
        , createEntityEditor = createIntegrationEditor
        , addEntity = addKMIntegration
        }
