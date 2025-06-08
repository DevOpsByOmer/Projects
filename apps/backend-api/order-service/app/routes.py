from flask import Blueprint, jsonify

bp = Blueprint("routes", __name__)

@bp.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "order-service is healthy"}), 200

@bp.route("/orders", methods=["GET"])
def get_orders():
    return jsonify({"orders": ["order1", "order2", "order3"]})
