module Shared.Data.KnowledgeModel.KnowledgeModelEntities exposing (KnowledgeModelEntities, decoder, updateQuestions)

import Dict exposing (Dict)
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import Shared.Data.KnowledgeModel.Answer as Answer exposing (Answer)
import Shared.Data.KnowledgeModel.Chapter as Chapter exposing (Chapter)
import Shared.Data.KnowledgeModel.Expert as Expert exposing (Expert)
import Shared.Data.KnowledgeModel.Integration as Integration exposing (Integration)
import Shared.Data.KnowledgeModel.Question as Question exposing (Question)
import Shared.Data.KnowledgeModel.Reference as Reference exposing (Reference)
import Shared.Data.KnowledgeModel.Tag as Tag exposing (Tag)


type alias KnowledgeModelEntities =
    { chapters : Dict String Chapter
    , questions : Dict String Question
    , answers : Dict String Answer
    , experts : Dict String Expert
    , references : Dict String Reference
    , integrations : Dict String Integration
    , tags : Dict String Tag
    }


decoder : Decoder KnowledgeModelEntities
decoder =
    D.succeed KnowledgeModelEntities
        |> D.required "chapters" (D.dict Chapter.decoder)
        |> D.required "questions" (D.dict Question.decoder)
        |> D.required "answers" (D.dict Answer.decoder)
        |> D.required "experts" (D.dict Expert.decoder)
        |> D.required "references" (D.dict Reference.decoder)
        |> D.required "integrations" (D.dict Integration.decoder)
        |> D.required "tags" (D.dict Tag.decoder)


updateQuestions : Dict String Question -> KnowledgeModelEntities -> KnowledgeModelEntities
updateQuestions newQuestions entities =
    { entities | questions = newQuestions }
