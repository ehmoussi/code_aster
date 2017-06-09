! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine lischk(nomo, phenoz, nomcmz, lischa)
!
!
    implicit      none
#include "jeveux.h"
#include "asterfort/lisccm.h"
#include "asterfort/lisccp.h"
#include "asterfort/liscom.h"
#include "asterfort/lisdbl.h"
#include "asterfort/lisver.h"
    character(len=*) :: nomcmz, phenoz
    character(len=8) :: nomo
    character(len=19) :: lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! VERIFICATION DE LA LISTE DES CHARGES
!
! ----------------------------------------------------------------------
!
!
! IN  NOMO   : NOM DU MODELE
! IN  PHENOM : TYPE DE PHENOMENE (MECANIQUE, THERMIQUE, ACOUSTIQUE)
! IN  NOMCMD : NOM DE LA COMMANDE
! IN  LISCHA : SD LISTE DES CHARGES
!
! ----------------------------------------------------------------------
!
    character(len=16) :: nomcmd, phenom
    character(len=1) :: codarr
!
! ----------------------------------------------------------------------
!
    nomcmd = nomcmz
    phenom = phenoz
    codarr = 'F'
!
! --- VERIFICATION DE LA COHERENCE DES MODELES
!
    call liscom(nomo, codarr, lischa)
!
! --- VERIFICATION COMPATIBILITE CHARGE/PHENOMENE
!
    call lisccp(phenom, lischa)
!
! --- VERIFICATION COMPATIBILITE CHARGE/COMMANDE
!
    call lisccm(nomcmd, codarr, lischa)
!
! --- VERIFICATIONS DES DOUBLONS
!
    call lisdbl(lischa)
!
! --- VERIFICATIONS DIVERSES SUR LES TYPES DE CHARGES
!
    call lisver(lischa)

end subroutine
