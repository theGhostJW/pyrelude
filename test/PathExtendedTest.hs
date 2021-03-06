
module PathExtendedTest where

import qualified Control.Monad.Catch     as C
import           Data.Either.Combinators
import           Pyrelude as P
import           Pyrelude.Test
import qualified Prelude as P

type PathParser ar fd = forall m s. (C.MonadCatch m, ConvertString s P.String) => s -> m (Either PathException (Path ar fd))

chkValid :: Text -> Text -> PathParser ar fd -> Assertion
chkValid expected parseTarget psr = do
                                      rslt <- psr parseTarget
                                      P.either
                                       (\l -> chkFail $ "Parsing expected valid path resulted in error: " <> show l)
                                       (\pth -> chkEq expected (toS $ toFilePath pth))
                                       rslt

chkInvalid :: Text -> PathParser ar fd -> Assertion
chkInvalid parseTarget psr = do
                               rslt <- psr parseTarget
                               chk $ isLeft rslt

unit_parseRelDirSafe_valid = chkValid "\\Temp\\" "\\Temp" parseRelDirSafe
unit_parseRelDirSafe_valid_nested = chkValid "\\Temp\\Data\\" "\\Temp\\Data" parseRelDirSafe

unit_parseRelDirSafe_invalid = chkInvalid "..\\Temp" parseRelDirSafe
unit_parseRelDirSafe_invalid_empty = chkInvalid "" parseRelDirSafe

unit_parseAbsDirSafe_valid = chkValid "C:\\Temp\\" "C:\\Temp" parseAbsDirSafe
unit_parseAbsDirSafe_valid_nested = chkValid "D:\\Temp\\Data\\" "D:\\Temp\\Data" parseAbsDirSafe

unit_parseAbsDirSafe_invalid = chkInvalid "\\Temp" parseAbsDirSafe
unit_parseAbsDirSafe_invalid_empty = chkInvalid "" parseAbsDirSafe

unit_parseRelFileSafe_valid = chkValid "\\Temp\\MyFile" "\\Temp\\MyFile" parseRelFileSafe
unit_parseRelFileSafe_valid_nested = chkValid "\\Temp\\Data\\MyFile.txt" "\\Temp\\Data\\MyFile.txt" parseRelFileSafe

unit_parseRelFileSafe_invalid = chkInvalid "..\\Temp\\MyFile" parseRelFileSafe
unit_parseRelFileSafe_invalid_empty = chkInvalid "" parseRelFileSafe

unit_parseAbsFileSafe_valid = chkValid "C:\\Temp\\MyFile" "C:\\Temp\\MyFile" parseAbsFileSafe
unit_parseAbsFileSafe_valid_nested = chkValid "D:\\Temp\\Data\\MyFile.csv" "D:\\Temp\\Data\\MyFile.csv" parseAbsFileSafe

unit_parseAbsFileSafe_invalid = chkInvalid "\\Temp\\MyFile.csv" parseAbsFileSafe
unit_parseAbsFileSafe_invalid_empty = chkInvalid "" parseAbsFileSafe
