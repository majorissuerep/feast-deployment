from feast import FeatureStore
from datetime import datetime
import pytest

def test_feature_store_config():
    store = FeatureStore("feature-repo/")
    assert store.config.project == "feast-project"
    assert store.config.provider == "local"
    assert store.config.online_store.type == "redis" 