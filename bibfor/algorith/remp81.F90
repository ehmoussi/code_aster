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

subroutine remp81(nomres, lpar, basmod, nbmod)
    implicit none
!
!  BUT : < REMPLISSAGE DES MACRO-ELEMENTS AVEC LES VALEURS GENERALISEES
!          RENSEIGNEES A LA MAIN >
!
!        LA MATRICE RESULTAT EST SYMETRIQUE ET STOCKEE TRIANGLE SUP
!
!-----------------------------------------------------------------------
!
! NOMRES /I/  : NOM K19 DE LA MATRICE CARREE RESULTAT
! LPAR   /I/  : ADRESSE POUR LE STOCKAGE DU PARAMETRE (MASSE, RAID...)
! BASMOD /K8/ : NOM UT DE LA BASE MODALE DE PROJECTION
! NBMOD  /I/  : NOMBRE DE MODES DANS LA BASE
!
!
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    character(len=8) :: basmod, blanc
    character(len=18) :: nomres
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ldres, ldref, lddes, nbmod, imod
    integer ::  ntail, lpar, i, iad
!-----------------------------------------------------------------------
    data blanc/'        '/
!-----------------------------------------------------------------------
!
! --- CREATION ET REMPLISSAGE DU _REFE
!
    call jemarq()
    call wkvect(nomres//'_REFE', 'G V K24', 2, ldref)
    zk24(ldref) = basmod
    zk24(ldref+1) = blanc
!
! --- CREATION ET REMPLISSAGE DU _VALE
!
    ntail=nbmod*(nbmod+1)/2     
    call jecrec(nomres//'_VALE', 'G V R', 'NU', 'DISPERSE', & 
                   'CONSTANT',1)   
    call jeecra(nomres//'_VALE', 'LONMAX', ntail)
    call jecroc(jexnum(nomres//'_VALE', 1))
    call jeveuo(jexnum(nomres//'_VALE', 1), 'E', ldres)
!   call wkvect(nomres//'_VALE', 'G V R', ntail, ldres)
!
    do  i = 1, ntail
        zr(ldres+i-1)=0.0d0
    end do
    do  imod = 1, nbmod
        iad=imod*(imod+1)/2
!
        zr(ldres+iad-1)=zr(lpar+imod-1)
    end do
!
!
! --- CREATION ET REMPLISSAGE DU .DESC
!
    call wkvect(nomres(1:18)//'_DESC', 'G V I', 3, lddes)
    zi(lddes) = 2
    zi(lddes+1) = nbmod
    zi(lddes+2) = 2
!
    call jedema()
end subroutine
