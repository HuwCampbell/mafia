{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Mafia.Path
  ( -- * Types
    Path
  , File
  , Directory

    -- * Filename/directory functions
  , (</>)
  , takeFileName
  , takeDirectory
  , makeRelative

    -- * Extension functions
  , takeExtension
  , dropExtension
  , extension
  ) where

import qualified Data.List as List
import           Data.Text (Text)
import qualified Data.Text as T

import           P

import qualified System.FilePath as FilePath

------------------------------------------------------------------------
-- Types

type Path      = Text
type File      = Path
type Directory = Path

------------------------------------------------------------------------
-- Filename/directory functions

(</>) :: Path -> Path -> Path
(</>) x y = T.pack (T.unpack x FilePath.</> T.unpack y)

takeFileName :: Path -> File
takeFileName = T.pack . FilePath.takeFileName . T.unpack

takeDirectory :: Path -> Directory
takeDirectory = T.pack . FilePath.takeDirectory . T.unpack

makeRelative :: Path -> Path -> Maybe Path
makeRelative xp yp =
  let xs@(x:_) = T.split (== '/') xp
      ys@(y:_) = T.split (== '/') yp

      n = length
        . List.takeWhile (== True)
        $ List.zipWith (==) xs ys

      m = length
        . drop n
        $ xs
  in
      if x == y
      then Just (T.intercalate "/" (List.replicate m ".." <> drop n ys))
      else Nothing

------------------------------------------------------------------------
-- Extension functions

takeExtension :: Path -> Text
takeExtension = T.pack . FilePath.takeExtension . T.unpack

dropExtension :: Path -> Path
dropExtension = T.pack . FilePath.dropExtension . T.unpack

extension :: Text -> Path -> Bool
extension ext = (== ext) . takeExtension