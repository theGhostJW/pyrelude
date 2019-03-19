module Pyrelude (
  module P
  , module Data.Maybe
  , module Data.Text.IO
  , module Control.Monad.Catch
  , module Debug.Trace.Extended
  , module Path.Extended
  , module Path.IO.Extended
  , module D
  , module Data.Either.Combinators
  , module THEx
  , module Stringy
  , module Data.Text
  , module Ternary
  , count
  , firstDuplicate
  , eitherf
  , maybef
  , enumList
  , Pyrelude.head
  , Pyrelude.last
  , Pyrelude.tail
  , Pyrelude.init
  , uu
) where

import           Control.Monad.Catch
import           BasePrelude as P hiding (
   
   -- hiding String et. al. -- favouring Text
   String, lines, words, unlines, unwords, readFile, writeFile,
   
   -- hiding groupy functions -- favouring Descrimination
   group, groupWith, nub, sort, sortWith,

   -- hiding in favour of safe versions
   head, last, tail, init,

   -- hidng in favour of Control.Monad.Catch -- exceptions
   -- TODO: work this out make sure behaviour is the same
   Handler, catches, bracket, bracketOnError, bracket_, catchJust, finally, handle, handleJust,
   onException, try, tryJust, catch, mask, mask_, uninterruptibleMask, uninterruptibleMask_, 
   catchIOError,

   -- favouring Data.Either.Combinators
   isLeft, fromRight, isRight, fromLeft,

   -- Favour Text
   toLower, toTitle, toUpper, 

   -- Favour Data.Text.IO
   appendFile, getContents, getLine, interact, putStr, putStrLn, 
     ) 
import Data.Text hiding (
  -- favouring Discrimination (need another module for these conflicts)
  group, 

  -- Favouring Prelude List
  reverse, dropWhile, concat, filter, map, zip, foldr, empty, foldl, foldl', 
  foldl1, foldr1, maximum, minimum, null, all, any, concatMap, find, partition,
  break, dropWhileEnd, findIndex, groupBy, inits, intercalate, intersperse, isInfixOf,
  isPrefixOf, isSuffixOf, stripPrefix, tails, transpose, unfoldr, mapAccumL, mapAccumR,
  drop, foldl1', head, init, last, replicate, length, scanl, scanl1, scanr, scanr1,
  span, splitAt, tail, take, takeWhile, uncons, zipWith, index, 

  -- favouring my own function
  count
  )
import           Data.Discrimination as D
import BasePrelude as B
import           Data.Either.Combinators
import qualified Data.List                           as L
import           Data.Maybe
import           Debug.Trace.Extended
import           Language.Haskell.TH.Syntax.Extended as THEx (moduleOf)
import           Path.Extended
import           Path.IO.Extended
import Stringy
import Ternary
import Data.Text.IO

-- undefined in less keystrokes
uu :: forall a. a
uu = undefined

count :: (Foldable f, Num n) => (a -> Bool) -> f a -> n
count p = P.foldl' (\n x -> p x ? n + 1 $ n) 0

firstDuplicate :: Grouping a => [a] -> Maybe a
firstDuplicate xs = L.find (\l -> P.length l > 1) (D.group xs) >>= Pyrelude.head

eitherf :: Either a b -> (a -> c) -> (b -> c) -> c
eitherf e lf rf = either lf rf e

maybef :: Maybe a -> b -> (a -> b) -> b
maybef m d f = maybe d f m

enumList :: Enum a => [a]
enumList = enumFrom $ toEnum 0

safe :: ([a] -> a) -> [a] -> Maybe a
safe f l  = null l ? Nothing $ Just $ f l

safeLst :: ([a] -> [a]) -> [a] -> Maybe [a]
safeLst f l  = null l ? Nothing $ Just $ f l

head :: [a] -> Maybe a
head = safe B.head

last :: [a] -> Maybe a
last = safe B.last

tail :: [a] -> Maybe [a]
tail = safeLst B.tail

init :: [a] -> Maybe [a]
init = safeLst B.init


