row = {'time_ms': '00:17:48.79', 'game_mode': 'SEARCHANDDESTROY_ROUND', 'map': 'COLOSSUS', 'team_name': 'CLOUD9 NEW YORK', 'team_score': 0, 'opp_name': 'G2 MINNESOTA', 'opp_score': 0, 'map_time': '0.0', 'time_left_in_current_hill': None, 'hill_number': None, 'side': 'CLOUD9 NEW YORK : defending, G2 MINNESOTA : attacking', 'team_A_lives': '3', 'team_B_lives': '4', 'point_secured': None, 'has_bomb': None, 'plant_site': None, 'first_blood': None, 'detonated': None, 'match_half': None, 'multikill': None, 'killing_spree': None, 'location': None, 'last_alive': None, 'tournament_info': None, 'win': None, 'round': None}

s1 = int(row['team_score']) if row['team_score'] is not None else None

print(s1)