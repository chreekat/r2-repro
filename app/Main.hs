{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.AWS
import Network.AWS.S3
import System.Environment
import System.IO
import Control.Lens (set)

import qualified Data.Text as T
import qualified Data.ByteString.Char8 as BS8

run :: IO PutObjectResponse
run = do
    aws <- do
        stdoutLog <- newLogger Debug stdout
        aws'' <- newEnv Discover
        endpoint <- lookup "AWS_S3_ENDPOINT" <$> getEnvironment
        let aws' = set envLogger stdoutLog aws''
        pure $ case endpoint of
            Nothing -> aws'
            Just ep -> configure (setEndpoint True (BS8.pack ep) 443 s3) aws'
    [bkt] <- getArgs
    let put = putObject (BucketName (T.pack bkt)) (ObjectKey "btest1") "some content"
    runResourceT $ runAWS aws $ send put

main :: IO ()
main = print =<< run
