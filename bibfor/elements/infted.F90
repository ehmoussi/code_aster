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

subroutine infted(nomte, symetr, nbterm, nbnoeu, nbcomp, ndimen, itype)
!
! person_in_charge: jean-luc.flejou at edf.fr
!
! --------------------------------------------------------------------------------------------------
!
!                 INFORMATIONS SUR LES DISCRETS ET POUTRES
!
! --------------------------------------------------------------------------------------------------
!
! IN
!     nomte : elements concernes :
!        meca_dis_tr_l     : maille a 2 noeuds en 3d
!        meca_dis_t_l      : maille a 2 noeuds en 3d
!        meca_dis_tr_n     : maille a 1 noeud  en 3d
!        meca_dis_t_n      : maille a 1 noeud  en 3d
!        meca_2d_dis_tr_l  : maille a 2 noeuds en 2d
!        meca_2d_dis_t_l   : maille a 2 noeuds en 2d
!        meca_2d_dis_tr_n  : maille a 1 noeud  en 2d
!        meca_2d_dis_t_n   : maille a 1 noeud  en 2d
!        meca_pou_d_t      : maille a 2 noeuds en 3d
!        meca_pou_d_e      : maille a 2 noeuds en 3d
!        meca_pou_d_em     : maille a 2 noeuds en 3d
!        meca_pou_d_tg     : maille a 2 noeuds en 3d
!        meca_pou_d_tgm    : maille a 2 noeuds en 3d
!
!     symetr : =1 non-symetrique, =2 non-symetrique (discrets seulement)
!
! out
!     nbterm : nombre de terme dans la matrice
!     nbnoeu : nombre de noeuds de l'element
!     nbcomp : nombre de composante par noeud
!     ndimen : dimension de l'element
!     itype  : type de l'element
!
! --------------------------------------------------------------------------------------------------
!
!     itype : dans ptenpo
!        poutre droite de section constante ou variable  : 0 1 2
!
!                                                  T  TR
!        discret type nodale  ..._N              : 20 21
!        discret type nodale  ..._N_NS           : 22 23
!        discret type liaison ..._L              : 40 41
!        discret type liaison ..._L_NS           : 42 43
!
! --------------------------------------------------------------------------------------------------
!
implicit none
!
!
    character(len=*) :: nomte
    integer :: symetr, nbterm, nbnoeu, nbcomp, ndimen, itype
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: kmess(5)
    integer :: iadzi, iazk24, iret
    real(kind=8) :: tvar
!
! --------------------------------------------------------------------------------------------------
!
    itype = -10
    if (nomte .eq. 'MECA_DIS_TR_L') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 78
            nbnoeu = 2
            nbcomp = 6
            ndimen = 3
            itype = 41
        else if (symetr.eq.2) then
            nbterm = 144
            nbnoeu = 2
            nbcomp = 6
            ndimen = 3
            itype = 43
        endif
    else if (nomte.eq.'MECA_DIS_TR_N') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 21
            nbnoeu = 1
            nbcomp = 6
            ndimen = 3
            itype = 21
        else if (symetr.eq.2) then
            nbterm = 36
            nbnoeu = 1
            nbcomp = 6
            ndimen = 3
            itype = 23
        endif
    else if (nomte.eq.'MECA_DIS_T_L') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 21
            nbnoeu = 2
            nbcomp = 3
            ndimen = 3
            itype = 40
        else if (symetr.eq.2) then
            nbterm = 36
            nbnoeu = 2
            nbcomp = 3
            ndimen = 3
            itype = 42
        endif
    else if (nomte.eq.'MECA_DIS_T_N') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 6
            nbnoeu = 1
            nbcomp = 3
            ndimen = 3
            itype = 20
        else if (symetr.eq.2) then
            nbterm = 9
            nbnoeu = 1
            nbcomp = 3
            ndimen = 3
            itype = 22
        endif
    else if (nomte.eq.'MECA_2D_DIS_TR_L') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 21
            nbnoeu = 2
            nbcomp = 3
            ndimen = 2
            itype = 41
        else if (symetr.eq.2) then
            nbterm = 36
            nbnoeu = 2
            nbcomp = 3
            ndimen = 2
            itype = 43
        endif
    else if (nomte.eq.'MECA_2D_DIS_TR_N') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 6
            nbnoeu = 1
            nbcomp = 3
            ndimen = 2
            itype = 21
        else if (symetr.eq.2) then
            nbterm = 9
            nbnoeu = 1
            nbcomp = 3
            ndimen = 2
            itype = 23
        endif
    else if (nomte.eq.'MECA_2D_DIS_T_L') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 10
            nbnoeu = 2
            nbcomp = 2
            ndimen = 2
            itype = 40
        else if (symetr.eq.2) then
            nbterm = 16
            nbnoeu = 2
            nbcomp = 2
            ndimen = 2
            itype = 42
        endif
    else if (nomte.eq.'MECA_2D_DIS_T_N') then
        ASSERT((symetr.eq.1).or.(symetr.eq.2))
        if (symetr .eq. 1) then
            nbterm = 3
            nbnoeu = 1
            nbcomp = 2
            ndimen = 2
            itype = 20
        else if (symetr.eq.2) then
            nbterm = 4
            nbnoeu = 1
            nbcomp = 2
            ndimen = 2
            itype = 22
        endif
!
!   Les poutres
    else if (nomte.eq.'MECA_POU_D_T') then
        nbterm = 78
        nbnoeu = 2
        nbcomp = 6
        ndimen = 3
        call poutre_modloc('CAGNPO', ['TVAR'], 1, valeur=tvar, arret='NNN', retour= iret)
        if (iret .eq. 0) itype = nint(tvar)
    else if (nomte.eq.'MECA_POU_D_E') then
        nbterm = 78
        nbnoeu = 2
        nbcomp = 6
        ndimen = 3
        call poutre_modloc('CAGNPO', ['TVAR'], 1, valeur=tvar, arret='NNN', retour= iret)
        if (iret .eq. 0) itype = nint(tvar)
    else if (nomte.eq.'MECA_POU_D_EM') then
        nbterm = 78
        nbnoeu = 2
        nbcomp = 6
        ndimen = 3
        call poutre_modloc('CAGNPO', ['TVAR'], 1, valeur=tvar, arret='NNN', retour= iret)
        if (iret .eq. 0) itype = nint(tvar)
    else if ( (nomte.eq.'MECA_POU_D_TG') .or. (nomte.eq.'MECA_POU_D_TGM') ) then
        nbterm = 105
        nbnoeu = 2
        nbcomp = 7
        ndimen = 3
        call poutre_modloc('CAGNPO', ['TVAR'], 1, valeur=tvar, arret='NNN', retour= iret)
        if (iret .eq. 0) itype = nint(tvar)
!
!   Elément pas traité
    else
        kmess(1) = nomte
        kmess(2) = 'INFTED'
        call tecael(iadzi, iazk24)
        kmess(3) = zk24(iazk24-1+3)
        call utmess('F', 'DISCRETS_13', nk=3, valk=kmess)
    endif
!
end subroutine
