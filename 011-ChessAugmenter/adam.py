import chess.pgn
import chess.engine

STOCKFISH_PATH = "C:\\Program Files\\stockfish\\stockfish-windows-x86-64-avx2.exe"

def eval_board(engine, board, time_limit=0.1):
    """Returnerar eval i centipawns för aktuell ställning (vit perspektiv)."""
    info = engine.analyse(board, chess.engine.Limit(time=time_limit))
    return info["score"].white().score(mate_score=100000)

def evaluate_game_with_best_moves(pgn_path, stockfish_path, time_limit=0.1):
    results = []

    with open(pgn_path) as f, chess.engine.SimpleEngine.popen_uci(stockfish_path) as engine:
        game = chess.pgn.read_game(f)
        board = game.board()

        move_number = 1

        for move in game.mainline_moves():
            # Hitta bästa draget i aktuell ställning
            best_info = engine.analyse(board, chess.engine.Limit(time=time_limit), multipv=5)
            best_score = best_info[0]["score"].white().score(mate_score=100000)
            best_move = best_info[0]["pv"][0]  # Första draget i bästa variant

            # Utför det faktiska draget
            played_move = move
            board.push(played_move)

            # Evalueringsvärde efter spelat drag
            actual_score = eval_board(engine, board, time_limit)

            # Beräkna loss
            loss = best_score - actual_score

            results.append({
                "move_number": move_number,
                "player": "White" if board.turn == chess.BLACK else "Black",  # Efter draget!
                "played": played_move.uci(),
                "best": best_move.uci(),
                "loss": loss
            })

            if board.turn == chess.WHITE:
                move_number += 1

    return results

results = evaluate_game_with_best_moves("pgn/helge-bergstrom_2025.06.02.pgn", STOCKFISH_PATH)

for entry in results:
    print(f"{entry['move_number']}. {entry['player']} played {entry['played']}, best was {entry['best']}, loss: {entry['loss']} cp")
