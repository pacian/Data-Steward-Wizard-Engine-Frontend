module Shared.Auth.Permission exposing
    ( dataManagementPlan
    , documents
    , hasPerm
    , knowledgeModel
    , knowledgeModelPublish
    , knowledgeModelUpgrade
    , packageManagementRead
    , packageManagementWrite
    , questionnaire
    , settings
    , submission
    , templates
    , userManagement
    )

import Maybe.Extra as Maybe
import Shared.Auth.Session exposing (Session)


hasPerm : Session -> String -> Bool
hasPerm session perm =
    List.any ((==) perm) (Maybe.unwrap [] .permissions session.user)


dataManagementPlan : String
dataManagementPlan =
    "DMP_PERM"


documents : String
documents =
    "DOC_PERM"


knowledgeModel : String
knowledgeModel =
    "KM_PERM"


knowledgeModelPublish : String
knowledgeModelPublish =
    "KM_PUBLISH_PERM"


knowledgeModelUpgrade : String
knowledgeModelUpgrade =
    "KM_UPGRADE_PERM"


packageManagementRead : String
packageManagementRead =
    "PM_READ_PERM"


packageManagementWrite : String
packageManagementWrite =
    "PM_WRITE_PERM"


questionnaire : String
questionnaire =
    "QTN_PERM"


settings : String
settings =
    "CFG_PERM"


submission : String
submission =
    "SUBM_PERM"


templates : String
templates =
    "TML_PERM"


userManagement : String
userManagement =
    "UM_PERM"
