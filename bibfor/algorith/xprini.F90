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

subroutine xprini(noma, cnxinv, grille, noesom, vcn,&
                  grlr, lcmin, ndim)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/conare.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/xprcnu.h"
!
    character(len=8) :: noma
    character(len=19) :: noesom, cnxinv
    character(len=24) :: vcn, grlr
    real(kind=8) :: lcmin
    integer :: ndim
    aster_logical :: grille
!
! person_in_charge: patrick.massin at edf.fr
!     ------------------------------------------------------------------
!
!       XPRINI   : X-FEM PROPAGATION 
!
!    ENTREE
!        NOMA    : NOM DU CONCEPT MAILLAGE
!        CNXINV  : CONNECTIVITE INVERSEE DU MAILLAGE NOMA
!        GRILLE  : .TRUE. SI NOMA EST UNE GRILLE AUXILIAIRE
!                  .FALSE. SI NOMA N'EST PAS UNE GRILLE AUXILIAIRE
!
!
!    SORTIE
!        NOESOM  : VECTEUR LOGIQUE INDIQUANT SI LE NOEUD EST SOMMET
!
!    EN PLUS, SI GRILLE=.FALSE. ET SI LA METHODE UPWIND_FMM EST UTILISEE,
!    ON A ON SORTIE LES OBJETS SUIVANTES:
!        VCN     : VOIR XPRCNU.F POUR LA DESCRIPTION DE CETTE OBJET.
!                  POUR LA METHODE SIMPLEXE, CET OBJET N'EST PAS UTILISE
!        GRLR    : VOIR XPRCNU.F POUR LA DESCRIPTION DE CETTE OBJET
!                  POUR LA METHODE SIMPLEXE, CET OBJET N'EST PAS UTILISE
!
!    SI GRILLE=.FALSE.
!        LCMIN   : LONGUEUR DE LA PLUS PETITE ARETE DE LA GRILLE
!
!     ------------------------------------------------------------------
!
    integer :: jconx1, jconx2, itypma
    integer :: ino, ima, ifm, niv, nbno, nbma, jnosom, ibid
    integer :: ar(12, 3), nbar, iar, na, nb, nunoa, nunob
    character(len=8) :: method, nomno, typma
    real(kind=8) :: dist
    real(kind=8), dimension(ndim) :: xa, xb, v
    integer, pointer :: mai(:) => null()
    real(kind=8), pointer :: vale(:) => null()
!-----------------------------------------------------------------------
!     DEBUT
!-----------------------------------------------------------------------
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
!
!   RETRIEVE THE DEFINITION OF THE ELEMENTS IN TERMS OF NODES
    call jeveuo(noma//'.CONNEX', 'L', jconx1)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', jconx2)
!
!   RETRIEVE THE TYPE OF EACH ELEMENT IN THE MESH
    call jeveuo(noma//'.TYPMAIL', 'L', vi=mai)
!
!   RETRIEVE THE COORDINATES OF THE NODES
    call jeveuo(noma//'.COORDO    .VALE', 'L', vr=vale)
!
!   RECUPERATION INFOS DU MAILLAGE
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbno)
!
    call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nbma)
!
!   RECUPERATION DE LA METHODE DE REINITIALISATION A EMPLOYER
    call getvtx(' ', 'METHODE', scal=method, nbret=ibid)
!
!
    if (method .eq. 'UPWIND' .and. (.not.grille)) then
        call xprcnu(noma, cnxinv, 'V', vcn, grlr,&
                    lcmin)
    endif
!
    if (method .ne. 'UPWIND' .and. (.not.grille)) then
!
        lcmin = r8gaem()
!
! boucle sur les mailles
        do ima = 1, nbma
            itypma=mai(ima)
            call jenuno(jexnum('&CATA.TM.NOMTM', itypma), typma)
            call conare(typma, ar, nbar)
            do iar = 1, nbar
                na=ar(iar,1)
                nb=ar(iar,2)
                nunoa=zi(jconx1-1+(zi(jconx2+ima-1)+na-1))
                nunob=zi(jconx1-1+(zi(jconx2+ima-1)+nb-1))
                xa(1:ndim) = vale(3*(nunoa-1)+1:3*(nunoa-1)+ndim)
                xb(1:ndim) = vale(3*(nunob-1)+1:3*(nunob-1)+ndim)
                v=xb-xa
                dist = sqrt(dot_product(v, v))
                lcmin = min(lcmin,dist)
            enddo
        enddo
    else
        write(ifm,*)'   LONGUEUR DE LA PLUS PETITE ARETE DU MAILLAGE:'&
     &               //' ',lcmin
    endif
!
!------------------------------------------------------------------
!     ON REPERE LES NOEUDS SOMMETS (DONT LE GRADIENT DE LS EST NUL)
!------------------------------------------------------------------
!
    call wkvect(noesom, 'V V L', nbno, jnosom)
    do ino = 1, nbno
        zl(jnosom-1+ino) = .true.
        call jenuno(jexnum(noma //'.NOMNOE', ino), nomno)
        if (nomno(1:2) .eq. 'NS') zl(jnosom-1+ino) = .false.
!
    end do
!
!-----------------------------------------------------------------------
!     FIN
!-----------------------------------------------------------------------
!
    call jedema()
end subroutine
