module KnowledgeModels.Editor.Models.Editors exposing (..)

import Form exposing (Form)
import KnowledgeModels.Editor.Models.Entities exposing (..)
import KnowledgeModels.Editor.Models.Forms exposing (..)


type KnowledgeModelEditor
    = KnowledgeModelEditor
        { active : Bool
        , form : Form () KnowledgeModelForm
        , knowledgeModel : KnowledgeModel
        , chapters : List ChapterEditor
        , chaptersDirty : Bool
        }


type ChapterEditor
    = ChapterEditor
        { active : Bool
        , form : Form () ChapterForm
        , chapter : Chapter
        , questions : List QuestionEditor
        , questionsDirty : Bool
        , order : Int
        }


type QuestionEditor
    = QuestionEditor
        { active : Bool
        , form : Form () QuestionForm
        , question : Question
        , answers : List AnswerEditor
        , answersDirty : Bool
        , references : List ReferenceEditor
        , referencesDirty : Bool
        , experts : List ExpertEditor
        , expertsDirty : Bool
        , order : Int
        }


type AnswerEditor
    = AnswerEditor
        { active : Bool
        , form : Form () AnswerForm
        , answer : Answer
        , followups : List QuestionEditor
        , order : Int
        }


type ReferenceEditor
    = ReferenceEditor
        { active : Bool
        , form : Form () ReferenceForm
        , reference : Reference
        , order : Int
        }


type ExpertEditor
    = ExpertEditor
        { active : Bool
        , form : Form () ExpertForm
        , expert : Expert
        , order : Int
        }


createKnowledgeModelEditor : KnowledgeModel -> KnowledgeModelEditor
createKnowledgeModelEditor knowledgeModel =
    let
        form =
            knowledgeModelFormInitials knowledgeModel
                |> initForm knowledgeModelFormValidation

        chapters =
            List.indexedMap (createChapterEditor False) knowledgeModel.chapters
    in
    KnowledgeModelEditor
        { active = True
        , form = form
        , knowledgeModel = knowledgeModel
        , chapters = chapters
        , chaptersDirty = False
        }


createChapterEditor : Bool -> Int -> Chapter -> ChapterEditor
createChapterEditor active order chapter =
    let
        form =
            initChapterForm chapter

        questions =
            List.indexedMap (createQuestionEditor False) chapter.questions
    in
    ChapterEditor
        { active = active
        , form = form
        , chapter = chapter
        , questions = questions
        , questionsDirty = False
        , order = order
        }


getChapterUuid : ChapterEditor -> String
getChapterUuid (ChapterEditor chapterEditor) =
    chapterEditor.chapter.uuid


activateChapter : ChapterEditor -> ChapterEditor
activateChapter (ChapterEditor chapterEditor) =
    ChapterEditor { chapterEditor | active = True }


matchChapter : String -> ChapterEditor -> Bool
matchChapter uuid (ChapterEditor chapterEditor) =
    chapterEditor.chapter.uuid == uuid


createQuestionEditor : Bool -> Int -> Question -> QuestionEditor
createQuestionEditor active order question =
    let
        form =
            questionFormInitials question
                |> initForm questionFormValidation

        answers =
            List.indexedMap (createAnswerEditor False) question.answers

        references =
            List.indexedMap (createReferenceEditor False) question.references

        experts =
            List.indexedMap (createExpertEditor False) question.experts
    in
    QuestionEditor
        { active = active
        , form = form
        , question = question
        , answers = answers
        , answersDirty = False
        , references = references
        , referencesDirty = False
        , experts = experts
        , expertsDirty = False
        , order = order
        }


getQuestionUuid : QuestionEditor -> String
getQuestionUuid (QuestionEditor questionEditor) =
    questionEditor.question.uuid


activateQuestion : QuestionEditor -> QuestionEditor
activateQuestion (QuestionEditor questionEditor) =
    QuestionEditor { questionEditor | active = True }


matchQuestion : String -> QuestionEditor -> Bool
matchQuestion uuid (QuestionEditor questionEditor) =
    questionEditor.question.uuid == uuid


createAnswerEditor : Bool -> Int -> Answer -> AnswerEditor
createAnswerEditor active order answer =
    let
        form =
            answerFormInitials answer
                |> initForm answerFormValidation

        followups =
            []
    in
    AnswerEditor
        { active = active
        , form = form
        , answer = answer
        , followups = followups
        , order = order
        }


getAnswerUuid : AnswerEditor -> String
getAnswerUuid (AnswerEditor answerEditor) =
    answerEditor.answer.uuid


activateAnswer : AnswerEditor -> AnswerEditor
activateAnswer (AnswerEditor answerEditor) =
    AnswerEditor { answerEditor | active = True }


matchAnswer : String -> AnswerEditor -> Bool
matchAnswer uuid (AnswerEditor answerEditor) =
    answerEditor.answer.uuid == uuid


createReferenceEditor : Bool -> Int -> Reference -> ReferenceEditor
createReferenceEditor active order reference =
    let
        form =
            referenceFormInitials reference
                |> initForm referenceFormValidation
    in
    ReferenceEditor
        { active = active
        , form = form
        , reference = reference
        , order = order
        }


getReferenceUuid : ReferenceEditor -> String
getReferenceUuid (ReferenceEditor referenceEditor) =
    referenceEditor.reference.uuid


activateReference : ReferenceEditor -> ReferenceEditor
activateReference (ReferenceEditor referenceEditor) =
    ReferenceEditor { referenceEditor | active = True }


matchReference : String -> ReferenceEditor -> Bool
matchReference uuid (ReferenceEditor referenceEditor) =
    referenceEditor.reference.uuid == uuid


createExpertEditor : Bool -> Int -> Expert -> ExpertEditor
createExpertEditor active order expert =
    let
        form =
            expertFormInitials expert
                |> initForm expertFormValidation
    in
    ExpertEditor
        { active = active
        , form = form
        , expert = expert
        , order = order
        }


getExpertUuid : ExpertEditor -> String
getExpertUuid (ExpertEditor expertEditor) =
    expertEditor.expert.uuid


activateExpert : ExpertEditor -> ExpertEditor
activateExpert (ExpertEditor expertEditor) =
    ExpertEditor { expertEditor | active = True }


matchExpert : String -> ExpertEditor -> Bool
matchExpert uuid (ExpertEditor expertEditor) =
    expertEditor.expert.uuid == uuid
