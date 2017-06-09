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

subroutine nxcerr(sddisc)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/ceil.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmlerr.h"
#include "asterfort/nxdocn.h" 
#include "asterfort/utdidt.h"
#include "asterfort/wkvect.h"
!
!
    character(len=19), intent(in) :: sddisc
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE THER_NON_LINE (STRUCTURES DE DONNES - SD DISCRETISATION)
!
! CREATION SD STOCKAGE DES INFOS EN COURS DE CALCUL
!
! --------------------------------------------------------------------------------------------------
!
! Inout  sddisc        : datastructure for time discretization
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: r8bid
    real(kind=8) :: resi_glob_rela, resi_glob_maxi, inikry
    real(kind=8), dimension(2) :: parcrr
    integer, dimension(3) :: parcri
    integer :: ibid, nbiter, iter_glob_maxi
    character(len=24) :: infocv, infore
    integer :: jifcv, jifre
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES PARAMETRES DU FICHIER DE COMMANDE
!
    call nxdocn(parcri, parcrr)
    iter_glob_maxi = parcri(3)
    resi_glob_rela = parcrr(2)
    resi_glob_maxi = parcrr(1)
!
    nbiter = iter_glob_maxi
!
! --- MEME VALEUR D'INITIALISATION QUE DANS NMCRSU
!
    inikry = 0.9d0
!
! --- CREATION DU VECTEUR D'INFORMATIONS SUR LA CONVERGENCE
!
    infocv = sddisc(1:19)//'.IFCV'
    call wkvect(infocv, 'V V R', 10, jifcv)
!
! --- NB MAX D'ITERATIONS : ITER_GLOB_MAXI
! --- RESIDUS     : RELA ET MAXI
!
    call nmlerr(sddisc, 'E', 'MXITER', r8bid, iter_glob_maxi)
    call nmlerr(sddisc, 'E', 'NBITER', r8bid, nbiter)
    call nmlerr(sddisc, 'E', 'RESI_GLOB_RELA', resi_glob_rela, ibid)
    call nmlerr(sddisc, 'E', 'RESI_GLOB_MAXI', resi_glob_maxi, ibid)
!
! --- RESIDU INITIAL POUR NEWTON-KRYLOV
!
    call nmlerr(sddisc, 'E', 'INIT_NEWTON_KRYLOV', inikry, ibid)
!
! --- RESIDU COURANT POUR NEWTON-KRYLOV
!
    call nmlerr(sddisc, 'E', 'ITER_NEWTON_KRYLOV', inikry, ibid)
!
! --- CREATION DU VECTEUR DE STOCKAGE DES RESIDUS
!
    nbiter = nbiter+1
    infore = sddisc(1:19)//'.IFRE'
    call wkvect(infore, 'V V R', 3*nbiter, jifre)
!
    call jedema()
end subroutine
