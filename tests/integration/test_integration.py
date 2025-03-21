import pytest
from feast import FeatureStore
import pandas as pd
from datetime import datetime, timedelta

def test_redis_connection():
    store = FeatureStore("feature-repo/")
    assert store.get_online_features(
        features=[
            "customer_features:total_orders",
            "customer_features:average_order_value"
        ],
        entity_rows=[{"customer_id": 1}]
    ).to_dict() is not None 