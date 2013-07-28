part of switchy_browser;

/*!
 * Copyright (C) 2012-2013, The SwitchyOmega Authors. Please see the AUTHORS file
 * for details.
 *
 * This file is part of SwitchyOmega.
 *
 * SwitchyOmega is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SwitchyOmega is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with SwitchyOmega.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Handles communication with the browser and other browser related stuff.
 */
abstract class Browser {
  AsyncStorage get storage;
  Future applyProfile(Profile profile);
}

/**
 * Provide a [Future]-based interface for accessing a storage.
 */
abstract class AsyncStorage {
  Future<Map<String, Object>> retive(List<String> names);
  Future put(Map<String, Object> map);
  Future remove(List<String> names);
}