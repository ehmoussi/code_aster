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

subroutine recupe(noma, ndim, nk1d, lrev, lmdb, &
                  matrev, matmdb, deklag, prodef,londef,&
                  oridef, profil)
    implicit none
#include "asterc/getfac.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: ndim, nk1d
    real(kind=8) :: lrev, lmdb, deklag, prodef, londef
    character(len=8) :: noma, matrev, matmdb, oridef
    character(len=12) :: profil
! --- BUT : RECUPERATION DES DONNEES DE LA COMMANDE POST_K_BETA --------
! ======================================================================
! OUT : NOMA   : NOM DU MAILLAGE ---------------------------------------
! --- : NDIM   : DIMENSION DE L'ESPACE ---------------------------------
! --- : NK1D   : NOMBRE D'OCCURENCE ------------------------------------
! --- : LREV   : EPAISSEUR DU REVETEMENT -------------------------------
! --- : LMDB   : EPAISSEUR DU METAL DE BASE ----------------------------
! --- : MATREV : MATERIAU DU REVETEMENT --------------------------------
! --- : MATMDB : MATERIAU DU METAL DE BASE -----------------------------
! --- : DEKLAG : DECALAGE DU DEFAUT ------------------------------------
! --- : PRODEF : PROFONDEUR DU DEFAUT ----------------------------------
! --- : LONDEF : LONGUEUR DU DEFAUT ------------------------------------
! --- : ORIDEF : ORIENTATION DU DEFAUT ---------------------------------
! --- : PROFIL : TYPE DE PROFIL (ELLIPSE OU SEMI-ELLIPSE) --------------
! ======================================================================
    integer :: ibid,ibid1,ibid2
    character(len=8) :: k8b
    character(len=16) :: motfac
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DU MAILLAGE -----------------------------------------
! ======================================================================
    call getvid(' ', 'MAILLAGE', scal=noma, nbret=ibid)
! ======================================================================
! --- DIMENSION DE L'ESPACE --------------------------------------------
! ======================================================================
    call dismoi('Z_CST', noma, 'MAILLAGE', repk=k8b)
    if (k8b(1:3) .eq. 'OUI') then
        ndim = 2
    else
        ndim = 3
    endif
! ======================================================================
! --- RECUPERATION DU PROFIL DE FISSURE --------------------------------
! ======================================================================
    call getvtx('FISSURE', 'FORM_FISS', iocc=1, scal=profil, nbret=ibid)
! ======================================================================
! --- RECUPERATION DES CARACTERISTIQUES DU REVETEMENT ------------------
! ======================================================================
    call getvr8(' ', 'EPAIS_REV', scal=lrev, nbret=ibid)
    call getvid(' ', 'MATER_REV', scal=matrev, nbret=ibid)
! ======================================================================
! --- RECUPERATION DES CARACTERISTIQUES DU METAL DE BASE ---------------
! ======================================================================
    lmdb   = 0.d0
    matmdb = '        '
    if(profil(1:12).eq.'SEMI_ELLIPSE')then
       call getvr8(' ', 'EPAIS_MDB', scal=lmdb, nbret=ibid1)
       call getvid(' ', 'MATER_MDB', scal=matmdb, nbret=ibid2)
       if((ibid1.eq.0).or.(ibid2.eq.0)) then
          call utmess('F', 'PREPOST_3')
       endif
!
    endif
! ======================================================================
! --- RECUPERATION DES DONNEES DE LA FISSURE ---------------------------
! ======================================================================
    if(profil(1:7).eq.'ELLIPSE') then
       call getvr8('FISSURE', 'DECALAGE', iocc=1, scal=deklag, nbret=ibid)
    else 
       deklag=0.d0
    endif
    call getvr8('FISSURE', 'PROFONDEUR', iocc=1, scal=prodef, nbret=ibid)
    call getvr8('FISSURE', 'LONGUEUR', iocc=1, scal=londef, nbret=ibid)
    call getvtx('FISSURE', 'ORIENTATION', iocc=1, scal=oridef, nbret=ibid)
! ======================================================================
! --- RECUPERATION DU NOMBRE D'OCCURENCE DE K1D ------------------------
! ======================================================================
    motfac = 'K1D'
    call getfac(motfac, nk1d)
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
