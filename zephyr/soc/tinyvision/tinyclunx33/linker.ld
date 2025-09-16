/*
 * Copyright (c) 2024-2025 tinyVision.ai Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

SECTION_PROLOGUE(nocache, (NOLOAD),)
{
	. = ALIGN(16);

	*(.nocache);
	*(.nocache.*);

} GROUP_LINK_IN(NOCACHE_REGION)
