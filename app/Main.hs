{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE CPP #-}

module Main where

#if MIN_VERSION_amazonka(2,0,0)
import Amazonka
import Amazonka.S3
import Amazonka.Env
#else
import Network.AWS
import Network.AWS.S3
#endif
import System.Environment
import System.IO
import Control.Lens (set)

import qualified Data.Text as T
import qualified Data.ByteString.Char8 as BS8

run :: IO PutObjectResponse
#if MIN_VERSION_amazonka(2,0,0)
run = do
    aws <- do
        stdoutLog <- newLogger Debug stdout
        aws'' <- newEnv discover
        endpoint' <- lookup "AWS_S3_ENDPOINT" <$> getEnvironment
        let aws' = set env_logger stdoutLog aws''
        pure $ case endpoint' of
            Nothing -> aws'
            Just ep -> configureService (setEndpoint True (BS8.pack ep) 443 defaultService) aws'
    [bkt] <- getArgs
    let put = newPutObject (BucketName (T.pack bkt)) (ObjectKey "btest1") (toBody $ replicate 1048576 'A')
    runResourceT $ send aws put
#else
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
#endif

main :: IO ()
main = print =<< run
